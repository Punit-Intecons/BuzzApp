import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/constant.dart';
import '../controller/web_api.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import 'chat_screen.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  DateTime? backPressedTime;
  late List<Message> userChats = [];
  bool isChatLoading = true;
  late SharedPreferences sharedPreferences;
  late String userID;
  late String userName;

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
      getChats();
    });
  }

  getChats() async {
    setState(() {
      isChatLoading = true;
      userChats.clear();
    });
    var getData = await WebConfig.getChats(
      userID: userID,
      userName: userName,
    );
    if (getData['status'] == true) {
      var list = getData['chats'];
      setState(() {
        for (int i = 0; i < list.length; i++) {
          userChats.add(Message(
            sender: User(
                id: list[i]['sender']['id'],
                name: list[i]['sender']['name'],
                imageUrl: list[i]['sender']['imageUrl'],
                isOnline: list[i]['sender']['isOnline']),
            time: list[i]['time'],
            text: list[i]['text'],
            unread: list[i]['unread'],
          ));
        }
        isChatLoading = false;
      });
    } else {
      setState(() {
        isChatLoading = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (backPressedTime == null ||
        DateTime.now().difference(backPressedTime!) >
            const Duration(seconds: 2)) {
      // prompt the user to confirm exit
      backPressedTime = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press again to exit'),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context,'inbox',userName);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: secondaryBackgroundColor,
        appBar: myAppBar,
        drawer: drawer,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // list of previous days
              Expanded(
                child: isChatLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : userChats.isNotEmpty
                        ? ListView.builder(
                            itemCount: userChats.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Message chat = userChats[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        user: chat.sender,
                                      ),
                                    ),
                                  ),
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
                                            radius: 35,
                                            backgroundImage: AssetImage(
                                                chat.sender.imageUrl),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        chat.sender.name,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    chat.time,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                          )
                        : const Center(
                            child: Text("No Chats found."),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
