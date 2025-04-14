import 'package:flutter/material.dart';
import '../models/glucosa_record.dart';
import 'glucosa_record_tile.dart';

class GlucosaRecordList extends StatelessWidget {
  final List<GlucosaRecord> records;
  final Function(GlucosaRecord) onRecordDeleted;

  const GlucosaRecordList({Key? key, required this.records, required this.onRecordDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        return GlucosaRecordTile(
          record: records[index],
          onRecordDeleted: onRecordDeleted,
        );
      },
    );
  }
}
