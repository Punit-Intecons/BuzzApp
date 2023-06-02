import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/my_data_table_source.dart';
import '../controller/constant.dart';
import 'package:file_picker/file_picker.dart';

import '../controller/web_api.dart';

class DesktopContacts extends StatefulWidget {
  const DesktopContacts({super.key});

  @override
  State<DesktopContacts> createState() => _DesktopContactsState();
}

class _DesktopContactsState extends State<DesktopContacts> {
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
    super.initState();
    getSharedData();
  }

  getSharedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString('userID')!;
      userName = sharedPreferences.getString('first_name')!;
    });

    getContactList();
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
        setState(() {
          for (int i = 0; i < list.length; i++) {
            List<String> rowData = [];
            for (var columnName in headers) {
              rowData.add(list[i][columnName]);
            }
            data.add(rowData);
          }
          rowsPerPage = (data.length < 20?data.length:20);
          isContactsLoading = false;
        });
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
      backgroundColor: secondaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            drawer,
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    // message text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 30, 0, 0),
                          child: Text(
                            'Contacts',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 30, 0, 0),
                          child: ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['csv', 'xls'],
                              );
                              if (result != null) {
                                setState(() {
                                  files = result.paths
                                      .map((path) => File(path!))
                                      .toList();
                                });
                                await EasyLoading.show();
                                var getData = await WebConfig.addContacts(
                                    files: files, userID: userID);
                                if (getData['status'] == true) {
                                  await EasyLoading.showSuccess(getData['msg']);
                                  getContactList();
                                } else {
                                  await EasyLoading.showError(getData['msg']);
                                }
                              }
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(110, 45),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(whiteColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                            ),
                            child: const Text('import'),
                          ),
                        ),
                      ],
                    ),

                    // search bar with icon
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 30, 450, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 8.0), // added left padding
                              child: Icon(Icons.search),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        8.0), // added horizontal padding
                                child: SizedBox(
                                  width: 10,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
