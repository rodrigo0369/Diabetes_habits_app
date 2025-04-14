import 'package:flutter/material.dart';
import '../models/glucosa_record.dart';
import '../widgets/add_glucosa_record_dialog.dart';
import '../widgets/glucosa_record_list.dart';

class GlucosaScreen extends StatefulWidget {
  @override
  _GlucosaScreenState createState() => _GlucosaScreenState();
}

class _GlucosaScreenState extends State<GlucosaScreen> {
  List<GlucosaRecord> _records = [];

  @override
  void initState() {
    super.initState();
    // Cargar registros guardados
  }

  void _addRecord(GlucosaRecord record) {
    setState(() {
      _records.add(record);
      // Guardar registro
    });
  }

  void _deleteRecord(GlucosaRecord record) {
    setState(() {
      _records.remove(record);
      // Eliminar registro
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Glucosa'),
      ),
      body: GlucosaRecordList(
        records: _records,
        onRecordDeleted: _deleteRecord,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddGlucosaRecordDialog(onRecordAdded: _addRecord),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
