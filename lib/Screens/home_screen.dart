import 'package:flutter/material.dart';
import '../models/habit.dart'; // Asegúrate de crear este modelo
import '../widgets/habit_list.dart'; // Y este widget
import '../widgets/habit_counter.dart';
import '../widgets/add_habit_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    // Cargar hábitos guardados (si los hay)
  }

  void _addHabit(Habit habit) {
    setState(() {
      _habits.add(habit);
      // Guardar el hábito
    });
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      habit.isCompleted = !habit.isCompleted;
      // Actualizar el hábito guardado
    });
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
