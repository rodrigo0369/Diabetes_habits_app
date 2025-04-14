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
  }

  Future<void> _loadHabits() async {
    final List<Map<String, dynamic>> encodedHabits = StorageService.getHabits();
    setState(() {
      _habits = encodedHabits.map((habit) => Habit.fromJson(habit)).toList();
    });
  }

  Future<void> _saveHabits() async {
    final List<Map<String, dynamic>> encodedHabits =
        _habits.map((habit) => habit.toJson()).toList();
    await StorageService.saveHabits(encodedHabits);
  }

  void _addHabit(Habit habit) {
    setState(() {
      _habits.add(habit);
    });
    _saveHabits();
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      habit.isCompleted = !habit.isCompleted;
    });
    _saveHabits();
  }

  void _editHabit(Habit oldHabit, Habit newHabit) {
    setState(() {
      final index = _habits.indexOf(oldHabit);
      if (index != -1) {
        _habits[index] = newHabit;
      }
    });
    _saveHabits();
  }

  void _deleteHabit(Habit habit) {
    setState(() {
      _habits.remove(habit);
    });
    _saveHabits();
  }

  @override
  Widget build(BuildContext context) {
    int _completedHabitsCount = _habits.where((habit) => habit.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hábitos Diarios'),
      ),
      body: Column(
        children: [
          HabitCounter(count: _completedHabitsCount),
          Expanded(
            child: HabitList(
              habits: _habits,
              onHabitToggled: _toggleHabit,
              onHabitEdited: _editHabit,
              onHabitDeleted: _deleteHabit,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddHabitDialog(onHabitAdded: _addHabit),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Añade estos métodos a la clase Habit
extension HabitPersistence on Habit {
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'reminderTime': reminderTime?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  static Habit fromJson(Map<String, dynamic> json) {
    return Habit(
      title: json['title'],
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      isCompleted: json['isCompleted'],
    );
  }
}
