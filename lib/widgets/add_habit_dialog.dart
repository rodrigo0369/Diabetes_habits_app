import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../l10n/app_localizations.dart'; // Importa

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
    final localizations = AppLocalizations.of(context); // Obtén la instancia

    return AlertDialog(
      title: Text(localizations!.translate('add_habit')), // Usa la traducción
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: localizations.translate('title')), // Usa la traducción
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.translate('please_enter_title'); // Usa la traducción
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
                    ? localizations.translate('select_reminder') // Usa la traducción
                    : '${localizations.translate('reminder')}: ${_reminderTime!.format(context)}', // Usa la traducción
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
          child: Text(localizations.translate('cancel')), // Usa la traducción
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
          child: Text(localizations.translate('save')), // Usa la traducción
        ),
      ],
    );
  }
}
