import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nikusiowo/constants.dart';
import 'package:restart_app/restart_app.dart';

import '../models/task.dart';

final whoWidgetProvider = StateProvider<String>((ref) => ref.read(sharedPreferencesProvider).getString("who") ?? "Niki");

class Avatar extends ConsumerWidget {
  final double? radius;
  final String? who;
  final String? taskName;
  const Avatar(this.radius,{this.who, this.taskName, super.key});

  void _changeUser(WidgetRef ref) {
    final newValue = ref.read(whoWidgetProvider.notifier).state == 'Niki' ? 'Piotrek' : 'Niki';
    ref.read(whoWidgetProvider.notifier).state = newValue;
    ref.read(sharedPreferencesProvider).setString("who", newValue);
    Restart.restartApp();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whoName = who ?? ref.watch(whoWidgetProvider.notifier).state;
    final img = whoName == "Niki" ? AssetImage('assets/Niki.png') : AssetImage('assets/Piotrek.png');
    return InkWell(
      onTap: () => who == null ? _changeUser(ref) : taskName == null ? null : ref.read(asyncTasksProvider.notifier).assign(taskName!),
        child: CircleAvatar(
            backgroundImage:img,
            radius: radius));
  }
}
