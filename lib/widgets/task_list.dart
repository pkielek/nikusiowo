import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nikusiowo/widgets/task_tile.dart';

import '../models/task.dart';
import 'circle_avatar.dart';

class TaskList extends ConsumerWidget {
  final List<Task> data;
  const TaskList(this.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(asyncTasksProvider);
    return ListView.separated(
        itemCount: data.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 5),
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          return TaskTile(
              taskData: data[index],
              avatar: Avatar(16,
                  who: data[index].who, taskName: data[index].name));
        });
  }
}
