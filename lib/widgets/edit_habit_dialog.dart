import 'package:flutter/material.dart';
import '../models/habit.dart';

class EditHabitDialog extends StatefulWidget {
  final Habit habit;
  final Function(Habit) onHabitEdited;

  const EditHabitDialog({Key? key, required this.habit, required this.onHabitEdited})
      : super(key: key);

  @override
  _EditHabitDialogState createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    _title = widget.habit.title;
    _reminderTime = widget.habit.reminderTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Hábito'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Título'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa un título';
                }
                return null;
              },
              onSaved: (value) {
                _title = value!;
              },
            ),
            ListTile(
              title: Text(
                _reminderTime == null
                    ? 'Seleccionar Recordatorio'
                    : 'Recordatorio: ${_reminderTime!.format(context)}',
              ),
              trailing: Icon(Icons.alarm_add),
              onTap: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  setState(() {
                    _reminderTime = selectedTime;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final updatedHabit = Habit(
                title: _title,
                reminderTime: _reminderTime,
                isCompleted: widget.habit.isCompleted,
              );
              widget.onHabitEdited(updatedHabit);
              Navigator.of(context).pop();
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
