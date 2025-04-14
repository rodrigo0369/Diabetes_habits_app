import 'package:flutter/material.dart';
import '../models/glucosa_record.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class GlucosaRecordTile extends StatelessWidget {
  final GlucosaRecord record;
  final Function(GlucosaRecord) onRecordDeleted;

  const GlucosaRecordTile({Key? key, required this.record, required this.onRecordDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Valor: ${record.value}'),
      subtitle: Text(DateFormat('dd/MM/yyyy hh:mm a').format(record.dateTime)),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          onRecordDeleted(record);
        },
      ),
    );
  }
}
