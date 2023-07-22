import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nikusiowo/widgets/circle_avatar.dart';

import '../constants.dart';

@immutable
class Task {
  const Task({
    required this.name,
    required this.type,
    required this.lastDone,
    required this.who,
  });
  
  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
      name: map['name'] as String,
      type: map['type'] as String,
      lastDone: (map['last_done'] as Timestamp).toDate(),
      who: map['who'] as String
    );
  }

  factory Task.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Task.fromJson(snapshot);
  }

  // All properties should be `final` on our class.
  final String name;
  final String type;
  final DateTime lastDone;
  final String who;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'type': type,
        'who': who,
        'last_done': lastDone.toLocal(),
      };
}

final taskTypes = {'Codzienne':1,'Co 2-3 dni':3, 'Co tydzień':7, 'Co 2 tygodnie': 14, 'Co miesiąc': 30, 'Dodatkowe':0};

class AsyncTasksNotifier extends AsyncNotifier<List<Task>> {
  Future<List<Task>> _fetchTask() async {
    final QuerySnapshot snapshot = await db.collection('tasks').orderBy('name').get();
    return snapshot.docs.map(Task.fromSnap).toList();
  }

  @override
  Future<List<Task>> build() async {
    return _fetchTask();
  }

  Future<void> refresh() async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
      return _fetchTask();
    });
  }

  Future<void> addTask(Task task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await db.collection("tasks").doc(task.name).set(task.toJson());
      return _fetchTask();
    });
  }

  Future<void> removeTask(String taskName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await db.collection("tasks").doc(taskName).delete();
      return _fetchTask();
    });
  }

  Future<void> assign(String taskName) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
      await db.collection("tasks").doc(taskName).update({'who':ref.read(whoWidgetProvider.notifier).state});
      return _fetchTask();
    });
  }

  Future<void> markIncomplete(String taskName, String type) async{
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
      await db.collection("tasks").doc(taskName).update({'last_done':Timestamp.fromDate(DateTime.now().subtract(Duration(days:taskTypes[type]!)))});
      return _fetchTask();
    });
  }

  Future<void> complete(String taskName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await db.collection("tasks").doc(taskName).update({"last_done":Timestamp.fromDate(DateTime.now()),'who':ref.read(whoWidgetProvider.notifier).state});
      return _fetchTask();
    });
  }
}

final asyncTasksProvider =
    AsyncNotifierProvider<AsyncTasksNotifier, List<Task>>(() {
  return AsyncTasksNotifier();
});
