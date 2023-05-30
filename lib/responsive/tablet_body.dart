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
    var drawer = myDrawer(context, 'inbox');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: secondaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          centerTitle: true,
          title: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: [
                TextSpan(
                    text: "Inbox",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
          ),
        ),
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
                        ? Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: userChats.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Message chat = userChats[index];
                                    return InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                            user: chat.sender,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, top: 10),
                                        child: ListTile(
                                          title: Text(
                                            chat.sender.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
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
                                          trailing: Text(
                                            chat.time,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
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
