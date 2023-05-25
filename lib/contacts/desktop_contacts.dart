import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';

import '../controller/web_api.dart';

class DesktopContacts extends StatefulWidget {
  const DesktopContacts({super.key});

  @override
  State<DesktopContacts> createState() => _DesktopContactsState();
}

class _DesktopContactsState extends State<DesktopContacts> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context, 'contacts');
    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            drawer,

            Expanded(
              flex: 1,
              child: SizedBox(
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
                            onPressed: () {
                              // Add your onPressed code here!
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
                      padding: const EdgeInsets.fromLTRB(16, 30, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: const [
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
                            child: Table(
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
                                      headers[i] as String == "Mobile"
                                          ? TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                        'Mobile Number',
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    headers[i] as String,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
