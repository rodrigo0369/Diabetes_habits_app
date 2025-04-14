import 'package:flutter/material.dart';
import '../models/habit.dart';

class AddHabitDialog extends StatefulWidget {
  final Function(Habit) onHabitAdded;

  const AddHabitDialog({Key? key, required this.onHabitAdded}) : super(key: key);

  @override
  _AddHabitDialogState createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  TimeOfDay? _reminderTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Hábito'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
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
              final newHabit = Habit(title: _title, reminderTime: _reminderTime);
              widget.onHabitAdded(newHabit);
              Navigator.of(context).pop();
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
