import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'alarm_icon.dart';
import 'edit_habit_dialog.dart'; // Importa el nuevo diálogo

class HabitTile extends StatelessWidget {
  final Habit habit;
  final Function(Habit) onHabitToggled;
  final Function(Habit) onHabitEdited; // Función para editar
  final Function(Habit) onHabitDeleted; // Función para eliminar

  const HabitTile({
    Key? key,
    required this.habit,
    required this.onHabitToggled,
    required this.onHabitEdited,
    required this.onHabitDeleted,
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (habit.reminderTime != null) AlarmIcon(),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EditHabitDialog(
                  habit: habit,
                  onHabitEdited: onHabitEdited,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Eliminar Hábito'),
                  content: Text('¿Seguro que quieres eliminar este hábito?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        onHabitDeleted(habit);
                        Navigator.of(context).pop();
                      },
                      child: Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
