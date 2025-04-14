import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'habit_tile.dart';

class HabitList extends StatelessWidget {
  final List<Habit> habits;
  final Function(Habit) onHabitToggled;

  const HabitList({
    Key? key,
    required this.habits,
    required this.onHabitToggled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return HabitTile(
          habit: habits[index],
          onHabitToggled: onHabitToggled,
        );
      },
    );
  }
}
