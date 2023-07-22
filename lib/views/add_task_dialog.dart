import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nikusiowo/widgets/circle_avatar.dart';

import '../models/task.dart';

final taskNameProvider = StateProvider<String>((ref) => "");
final taskTypeProvider = StateProvider<String>((ref) => taskTypes.keys.first);

class AddTaskDialog extends ConsumerWidget {
  const AddTaskDialog({super.key});

  void _addTask(WidgetRef ref) {
    ref.read(asyncTasksProvider.notifier).addTask(Task.fromJson({
          "name": ref.read(taskNameProvider.notifier).state,
          "type": ref.read(taskTypeProvider.notifier).state,
          "last_done": Timestamp.fromDate(DateTime.fromMicrosecondsSinceEpoch(0)),
          "who": ref.read(whoWidgetProvider.notifier).state
        }));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Dodaj Nikusiowego taska"),
      content: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Form(
            child: Column(children: [
          TextFormField(
            onChanged: (value) =>
                ref.read(taskNameProvider.notifier).state = value,
            decoration: const InputDecoration(labelText: 'Nazwa'),
          ),
          const SizedBox(height: 15),
          DropdownButton(
              value: ref.watch(taskTypeProvider),
              isExpanded: true,
              items: taskTypes.keys
                  .toList()
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? value) =>
                  ref.read(taskTypeProvider.notifier).state = value as String)
        ]))
      ])),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Anuluj'),
          child: const Text('Anuluj'),
        ),
        TextButton(
          onPressed: () => _addTask(ref),
          child: const Text('Dodaj Task'),
        ),
      ],
    );
  }
}
