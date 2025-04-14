import 'package:flutter/material.dart';
import '../models/glucosa_record.dart';
import '../widgets/add_glucosa_record_dialog.dart';
import '../widgets/glucosa_record_list.dart';
import '../services/storage_service.dart'; // Importa el servicio

class GlucosaScreen extends StatefulWidget {
  @override
  _GlucosaScreenState createState() => _GlucosaScreenState();
}

class _GlucosaScreenState extends State<GlucosaScreen> {
  List<GlucosaRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadGlucosaRecords();
  }

  Future<void> _loadGlucosaRecords() async {
    final List<Map<String, dynamic>> encodedRecords =
        StorageService.getGlucosaRecords();
    setState(() {
      _records = encodedRecords.map((record) => GlucosaRecord.fromJson(record)).toList();
    });
  }

  Future<void> _saveGlucosaRecords() async {
    final List<Map<String, dynamic>> encodedRecords =
        _records.map((record) => record.toJson()).toList();
    await StorageService.saveGlucosaRecords(encodedRecords);
  }

  void _addRecord(GlucosaRecord record) {
    setState(() {
      _records.add(record);
    });
    _saveGlucosaRecords();
  }

  void _deleteRecord(GlucosaRecord record) {
    setState(() {
      _records.remove(record);
    });
    _saveGlucosaRecords();
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

// Añade estos métodos a la clase GlucosaRecord
extension GlucosaRecordPersistence on GlucosaRecord {
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  static GlucosaRecord fromJson(Map<String, dynamic> json) {
    return GlucosaRecord(
      value: json['value'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
