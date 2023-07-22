import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nikusiowo/views/add_task_dialog.dart';
import 'package:nikusiowo/widgets/circle_avatar.dart';
import 'package:collection/collection.dart';

import '../models/task.dart';
import '../widgets/task_tile.dart';

class MainListView extends ConsumerWidget {
  const MainListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksGrouped = ref.watch(asyncTasksProvider).when(
        data: (data) => groupBy((data), (task) => task.type),
        error: (error, stackTrace) => {},
        loading: () => {});
    final groupKeys = tasksGrouped.keys.toList()
      ..sort((a, b) => taskTypes[a]!.compareTo(taskTypes[b]!));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nikusiowo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => {ref.read(asyncTasksProvider.notifier).refresh()},
          ),
          const Avatar(24),
          SizedBox(width: 15)
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: groupKeys.length + 1,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Image.asset(
                    "assets/dance.gif",
                    height: 125.0,
                    width: 125.0,
                  );
                }
                final groupKey = groupKeys[index - 1];
                return ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(groupKey),
                  children: (tasksGrouped[groupKey] as List<Task>)
                      .map((Task task) => TaskTile(
                          taskData: task,
                          avatar:
                              Avatar(16, who: task.who, taskName: task.name)))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 60.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AddTaskDialog()),
        tooltip: 'Dodaj zadanie',
        child: Icon(Icons.add),
      ),
    );
  }
}
