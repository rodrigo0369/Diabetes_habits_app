import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'alarm_icon.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final Function(Habit) onHabitToggled;

  const HabitTile({
    Key? key,
    required this.habit,
    required this.onHabitToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: habit.isCompleted,
        onChanged: (bool? value) {
          if (value != null) {
            onHabitToggled(habit);
          }
        },
      ),
      title: Text(habit.title),
      trailing: habit.reminderTime != null ? AlarmIcon() : null,
    );
  }
}
