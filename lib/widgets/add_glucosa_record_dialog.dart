import 'package:flutter/material.dart';
import '../models/glucosa_record.dart';

class AddGlucosaRecordDialog extends StatefulWidget {
  final Function(GlucosaRecord) onRecordAdded;

  const AddGlucosaRecordDialog({Key? key, required this.onRecordAdded}) : super(key: key);

  @override
  _AddGlucosaRecordDialogState createState() => _AddGlucosaRecordDialogState();
}

class _AddGlucosaRecordDialogState extends State<AddGlucosaRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nuevo Registro de Glucosa'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Valor de Glucosa'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingresa un valor';
            }
            final doubleValue = double.tryParse(value);
            if (doubleValue == null) {
              return 'Por favor, ingresa un número válido';
            }
            return null;
          },
          onSaved: (value) {
            _value = double.parse(value!);
          },
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
              final newRecord = GlucosaRecord(value: _value, dateTime: DateTime.now());
              widget.onRecordAdded(newRecord);
              Navigator.of(context).pop();
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
