import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart'; // Importa

class HabitCounter extends StatelessWidget {
  final int count;

  const HabitCounter({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Obtén la instancia

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('${localizations!.translate('habits_completed_today')}: $count'), // Usa la traducción
    );
  }
}
