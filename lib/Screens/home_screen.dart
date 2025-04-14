import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_list.dart';
import '../widgets/habit_counter.dart';
import '../widgets/add_habit_dialog.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../l10n/app_localizations.dart'; // Importa

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ... (Código anterior sin cambios importantes)

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Obtén la instancia

    int _completedHabitsCount = _habits.where((habit) => habit.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.translate('habits')), // Usa la traducción
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

  // ... (Código anterior de la clase _HomeScreenState)
}
