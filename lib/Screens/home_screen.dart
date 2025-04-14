import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_list.dart';
import '../widgets/habit_counter.dart';
import '../widgets/add_habit_dialog.dart';
import '../services/storage_service.dart'; // Importa el servicio

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];

@override
void initState() {
  super.initState();
  _loadHabits();
  _scheduleHabitNotifications(); //  Programa las notificaciones
}

Future<void> _scheduleHabitNotifications() async {
  for (var habit in _habits) {
    if (habit.reminderTime != null) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        habit.reminderTime!.hour,
        habit.reminderTime!.minute,
      );
      if (scheduledTime.isAfter(now)) {
        NotificationService.scheduleNotification(
          id: _habits.indexOf(habit), //  Usa el índice como ID (¡Cuidado con los duplicados!)
          title: 'Recordatorio de Hábito',
          body: '¡No olvides: ${habit.title}!',
          scheduledDate: scheduledTime,
        );
      }
    }
  }
}

void _addHabit(Habit habit) {
  setState(() {
    _habits.add(habit);
  });
  _saveHabits();
  if (habit.reminderTime != null) {
    _scheduleHabitNotification(habit); //  Programa la notificación para el nuevo hábito
  }
}

void _editHabit(Habit oldHabit, Habit newHabit) {
  setState(() {
    final index = _habits.indexOf(oldHabit);
    if (index != -1) {
      _habits[index] = newHabit;
    }
  });
  _saveHabits();
  if (newHabit.reminderTime != oldHabit.reminderTime) {
    NotificationService.cancelNotification(_habits.indexOf(oldHabit)); //  Cancela la anterior
    if (newHabit.reminderTime != null) {
      _scheduleHabitNotification(newHabit); //  Programa la nueva
    }
  }
}

void _deleteHabit(Habit habit) {
  setState(() {
    _habits.remove(habit);
  });
  _saveHabits();
  NotificationService.cancelNotification(_habits.indexOf(habit)); //  Cancela la notificación
}

Future<void> _scheduleHabitNotification(Habit habit) async {
  if (habit.reminderTime != null) {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      habit.reminderTime!.hour,
      habit.reminderTime!.minute,
    );
    if (scheduledTime.isAfter(now)) {
      await NotificationService.scheduleNotification(
        id: _habits.indexOf(habit),
        title: 'Recordatorio de Hábito',
        body: '¡No olvides: ${habit.title}!',
        scheduledDate: scheduledTime,
      );
    }
  }
}
