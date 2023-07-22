import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nikusiowo/constants.dart';

import '../models/task.dart';
import 'circle_avatar.dart';

class TaskTile extends ConsumerWidget {
  final Task taskData;
  final Widget avatar;
  final Expanded? text;
  final TextSpan? subtext;
  const TaskTile(
      {Key? key,
      required this.taskData,
      required this.avatar,
      this.text,
      this.subtext})
      : super(key: key);

  Expanded removeIcon(String taskName, WidgetRef ref) {
    return Expanded(
        flex: 2,
        child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () =>
                {ref.read(asyncTasksProvider.notifier).removeTask(taskName)}));
  }

  Expanded completeIcon(String taskName, WidgetRef ref) {
    return Expanded(
        flex: 2,
        child: IconButton(
            icon: const Icon(Icons.done, color: Colors.green),
            onPressed: () =>
                {ref.read(asyncTasksProvider.notifier).complete(taskName)}));
  }

  Expanded incompleteIcon(String taskName, String type, WidgetRef ref) {
    return Expanded(
        flex: 2,
        child: IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.orange),
            onPressed: () => {
                  ref
                      .read(asyncTasksProvider.notifier)
                      .markIncomplete(taskName, type)
                }));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final int daysLeft = -(taskData.lastDone
            .copyWith(year: now.year, month: now.month, day: now.day)
            .difference(taskData.lastDone)
            .inDays -
        taskTypes[taskData.type]!);
    final Color color = daysLeft.sign > 0
        ? Colors.green.withOpacity(0.15)
        : daysLeft.sign == 0
            ? Colors.yellow.withOpacity(0.15)
            : Colors.red.withOpacity(0.15);
    Widget textWidget = text ??
        RichText(
            text: TextSpan(
                text: taskData.name.toTitleCase(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
                children: subtext != null ? [subtext!] : null));
    textWidget = Expanded(flex: 13, child: textWidget);
    return Container(
        margin: EdgeInsets.only(top: 8.0),
        padding: EdgeInsets.only(left: 12.0),
        height: 60,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(children: <Widget>[
          textWidget,
          Expanded(
              flex: 2,
              child: Avatar(16, who: taskData.who, taskName: taskData.name)),
          completeIcon(taskData.name, ref),
          incompleteIcon(taskData.name, taskData.type, ref),
          removeIcon(taskData.name, ref)
        ]));
  }
}
