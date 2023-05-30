import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late String userID;
  late String userName;
  List<String> headers = [];
  List<List<String>> data = [];
  List<File> files = [];
  bool isContactsLoading = true;
  @override
  void initState() {
    getSharedData();
    headers = [
      'Mobile',
      'Attribute 1',
      'Attribute 2',
      'Attribute 3',
      'Tag 1',
      'Attribute 4'
    ];

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
      var list = getData['list'];
      setState(() {
        for (int i = 0; i < list.length; i++) {
          data.add([
            list[i]['Mobile_Number'],
            list[i]['Attribute_1'],
            list[i]['Attribute_2'],
            list[i]['Attribute_3'],
            list[i]['Tag'],
            list[i]['Added_on'],
          ]);
        }
        isContactsLoading = false;
      });
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
                  child: data.isNotEmpty
                      ? Table(
                          border: TableBorder.all(
                            color: greyColor,
                            width: 1.0,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          defaultColumnWidth: const FixedColumnWidth(120.0),
                          children: [
                            // Header row
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        '#',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: blackColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Dynamic columns
                                for (var i = 0; i < headers.length; i++)
                                  headers[i] == "Mobile"
                                      ? const TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    color: blackColor,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Mobile',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: blackColor,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                headers[i],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: blackColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                              ],
                            ),
                            // Dynamic rows
                            for (var j = 0; j < data.length; j++)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text((j + 1).toString()),
                                      ),
                                    ),
                                  ),
                                  // Dynamic cells
                                  for (var k = 0; k < data[j].length; k++)
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            data[j][k],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        )
                      : const Center(
                          child: Text("No Contact found"),
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
