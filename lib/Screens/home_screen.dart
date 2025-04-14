import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_list.dart';
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

  void _editHabit(Habit oldHabit, Habit newHabit) {
    setState(() {
      final index = _habits.indexOf(oldHabit);
      if (index != -1) {
        _habits[index] = newHabit;
        // Actualizar el hábito guardado
      }
    });
  }

  void _deleteHabit(Habit habit) {
    setState(() {
      _habits.remove(habit);
      // Eliminar el hábito guardado
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
              onHabitEdited: _editHabit, // Pasa la función para editar
              onHabitDeleted: _deleteHabit, // Pasa la función para eliminar
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
