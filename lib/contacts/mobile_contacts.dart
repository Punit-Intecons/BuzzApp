import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/my_data_table_source.dart';
import '../controller/constant.dart';
import 'package:file_picker/file_picker.dart';
import '../controller/web_api.dart';

class MobileContacts extends StatefulWidget {
  const MobileContacts({super.key});

  @override
  State<MobileContacts> createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  late SharedPreferences sharedPreferences;
  late String userID='';
  late String userName='';
  List<String> headers = [];
  List<List<String>> data = [];
  List<File> files = [];
  bool isContactsLoading = true;
  int rowsPerPage = 10; // Number of rows to display per page
  int currentPage = 0;
  @override
  void initState() {
    getSharedData();
    super.initState();
  }

  getSharedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString('userID')!;
      userName = sharedPreferences.getString('first_name')!;
      getContactList();
    });
  }

  getContactList() async {
    setState(() {
      isContactsLoading = true;
      data.clear();
    });
    var getData = await WebConfig.getContactsList(userID: userID);
    if (getData['status'] == true) {
      var list = getData['contacts'];
      if (list != null && list.isNotEmpty) {
        var firstContact = list[0];
        headers = firstContact.keys.toList(); // Extract column names
        if (mounted) {
          setState(() {
            for (int i = 0; i < list.length; i++) {
              List<String> rowData = [];
              for (var columnName in headers) {
                rowData.add(list[i][columnName]);
              }
              data.add(rowData);
            }
            rowsPerPage = (data.length < 20 ? data.length : 20);
            isContactsLoading = false;
          });
        }
      }
    } else {
      setState(() {
        isContactsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context, 'contacts',userName);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                  text: "Contacts",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
      ),
      drawer: drawer,
      body: isContactsLoading == true
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  header: const Text('Table'),
                  columns: [
                    const DataColumn(label: Text('#')),
                    // Dynamic columns
                    for (var i = 0; i < headers.length; i++)
                      DataColumn(
                        label: headers[i] == 'Mobile'
                        ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: blackColor,
                              size: 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Mobile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: blackColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                        : Text(
                          headers[i],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                  source: MyContactDataTableSource(data),
                  rowsPerPage: rowsPerPage,
                  availableRowsPerPage: const [10, 20, 25], // Number of rows per page options
                  onPageChanged: (pageIndex) {
                    setState(() {
                      currentPage = pageIndex;
                    });
                  },
                ),
              ),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['csv', 'xls'],
          );
          if (result != null) {
            setState(() {
              files = result.paths.map((path) => File(path!)).toList();
            });
            await EasyLoading.show();
            var getData =
                await WebConfig.addContacts(files: files, userID: userID);
            if (getData['status'] == true) {
              await EasyLoading.showSuccess(getData['msg']);
              getContactList();
            } else {
              await EasyLoading.showError(getData['msg']);
            }
          }
        },
        tooltip: 'Import contacts',
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
