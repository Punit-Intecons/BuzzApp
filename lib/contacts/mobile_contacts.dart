import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';

import '../controller/web_api.dart';

class MobileContacts extends StatefulWidget {
  const MobileContacts({super.key});

  @override
  State<MobileContacts> createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  bool isContactLoading = true;
  late SharedPreferences sharedPreferences;
  late String userID;
  late String userName;
  List<String> headers = [];
  List<List<String>> data = [];
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
    data = [
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
      ['7976970439', 'TOI', 'TOI', 'TOI', 'Intecons', 'Eng'],
    ];
    super.initState();
  }

  getSharedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString('userID')!;
      userName = sharedPreferences.getString('first_name')!;
      isContactLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context, 'contacts',userName);
    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      appBar: myAppBar,
      drawer: drawer,
      body: isContactLoading == true
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
                  child: Table(
                    border: TableBorder.all(
                      color: greyColor,
                      width: 1.0,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                            headers[i] as String == "Mobile"
                                ? TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
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
                                                fontWeight: FontWeight.bold,
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
                                          headers[i] as String,
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
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Import contacts',
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
