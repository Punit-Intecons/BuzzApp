import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_box.dart';
import 'package:buzzapp/components/my_tile.dart';

import '../controller/constant.dart';
import '../models/message_model.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context);
    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      appBar: myAppBar,
      drawer: drawer,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // list of previous days
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (BuildContext context, int index) {
                  final Message chat = chats[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: GestureDetector(
                      onTap: () => {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          // add this line
                          color: whiteColor, // add this line
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: chat.unread
                                  ? BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40)),
                                      border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      // shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    AssetImage(chat.sender.imageUrl),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              padding: const EdgeInsets.only(
                                left: 20,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            chat.sender.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        chat.time,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      chat.text,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
