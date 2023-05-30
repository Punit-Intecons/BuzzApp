import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MobileNumberUploadPage extends StatefulWidget {
  static const routeName = '/import';
  @override
  _MobileNumberUploadPageState createState() => _MobileNumberUploadPageState();
}

class _MobileNumberUploadPageState extends State<MobileNumberUploadPage> {
  String? selectedColumnHeader;
  List<List<dynamic>> csvData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload CSV'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedColumnHeader,
              hint: Text('Select Mobile Number Column'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedColumnHeader = newValue;
                });
              },
              items: getColumnHeaderDropdownItems(),
            ),
            ElevatedButton(
              onPressed: processSelectedMobileNumberField,
              child: Text('Process Selected Mobile Number Field'),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getColumnHeaderDropdownItems() {
    return csvData.isNotEmpty
        ? csvData[0]
            .map(
              (dynamic columnHeader) => DropdownMenuItem<String>(
                value: columnHeader.toString(),
                child: Text(columnHeader.toString()),
              ),
            )
            .toList()
        : [];
  }

  Future<void> uploadCSVFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      var csvString = await DefaultAssetBundle.of(context).loadString("$file");

      // Read the CSV file
      // final csvString = await file.readAsString();

      // Parse the CSV data
      csvData = CsvToListConverter().convert(csvString);
    }
  }

  void processSelectedMobileNumberField() {
    if (selectedColumnHeader != null) {
      final columnIndex = csvData[0].indexOf(selectedColumnHeader);

      if (columnIndex != -1) {
        final mobileNumbers = csvData
            .skip(1) // Skip the first row (header row)
            .map((row) => row[columnIndex].toString())
            .toList();

        // Handle the mobile numbers as needed
        print('Mobile Numbers: $mobileNumbers');
      } else {
        print('Selected column header not found in the CSV file');
      }
    }
  }
}
