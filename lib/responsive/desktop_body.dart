import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_box.dart';
import 'package:buzzapp/components/my_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controller/constant.dart';
import 'package:buzzapp/models/message_model.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context);
    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            drawer,

            // first half of page
            Expanded(
              flex: 1,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    // message text
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 30, 0, 0),
                      // padding:
                      // EdgeInsets.symmetric(vertical: 3.0, horizontal: 16),
                      child: Text(
                        'Message',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
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
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // list of previous days

                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
                      child: Text(
                        'New Messages',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: greyColor,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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
                                width: 10,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(40)),
                                              border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              // shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            )
                                          : BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                      child: CircleAvatar(
                                        radius: ((MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3) *
                                            0.035),
                                        backgroundImage:
                                            AssetImage(chat.sender.imageUrl),
                                      ),
                                    ),
                                    Container(
                                      width:
                                          ((MediaQuery.of(context).size.width /
                                                  3) *
                                              .5),
                                      padding: const EdgeInsets.only(
                                        left: 15,
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
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
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
                                                fontSize: 12,
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
            ),

            // second half of page
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
