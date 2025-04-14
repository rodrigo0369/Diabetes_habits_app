import 'package:flutter/material.dart';

class HabitCounter extends StatelessWidget {
  final int count;

  const HabitCounter({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Hábitos completados hoy: $count'),
    );
  }
}
