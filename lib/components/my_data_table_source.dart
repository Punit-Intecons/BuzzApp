import 'package:flutter/material.dart';

class MyDataTableSource extends DataTableSource {
  final List<List<String>> data;

  MyDataTableSource(this.data);

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

class MyContactDataTableSource extends DataTableSource {
  final List<List<String>> data;

  MyContactDataTableSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final item = data[index];
    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      for (var k = 0; k < item.length; k++) DataCell(Text(item[k])),
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
