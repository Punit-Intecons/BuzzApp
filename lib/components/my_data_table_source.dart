import 'package:flutter/material.dart';

class MyDataTableSource extends DataTableSource {
  final List<List<String>> data;
  final List<String> headers;

  MyDataTableSource(this.data, this.headers);

  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final row = data[index];
    return DataRow(cells: [
      for (var value in row)
        DataCell(Text(value)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}