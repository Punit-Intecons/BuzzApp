import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';
import 'package:buzzapp/models/message_model.dart';

import '../controller/web_api.dart';
import '../models/user_model.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  late List<Message> userMessages = [];
  late List<Message> userChats = [];
  bool isLoading = true;
  bool isChatLoading = true;
  bool isloadingFirstTime = true;
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

      isloadingFirstTime = true;
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

  getUserMessages() async {
    setState(() {
      isLoading = true;
      isloadingFirstTime = false;
      userMessages.clear();
    });
    var getData = await WebConfig.getMessages(
      userID: userID,
      userName: userName,
    );
    if (getData['status'] == true) {
      var list = getData['Messages'];
      setState(() {
        for (int i = 0; i < list.length; i++) {
          userMessages.add(Message(
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
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  _sendMessageArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 70,
      color: Colors.white,
      child: Container(
        color: secondaryBackgroundColor,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo),
              iconSize: 25,
              color: primaryColor,
              onPressed: () {},
            ),
            const Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(
                    hintText: 'Send a message..',
                    fillColor: secondaryBackgroundColor),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              iconSize: 25,
              color: primaryColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  _chatBubble(Message message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: whiteColor,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      message.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Text(
                      message.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context, 'inbox');
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
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: whiteColor,
                  ),
                  width: MediaQuery.of(context).size.width / 5,
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
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[100],
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
                        padding: EdgeInsets.fromLTRB(16, 20, 10, 0),
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final Message chat =
                                                userChats[index];
                                            return InkWell(
                                              onTap: (() {
                                                setState(() {
                                                  isLoading = true;
                                                  getUserMessages();
                                                });
                                              }),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 4.0, top: 10),
                                                child: ListTile(
                                                  title: Text(
                                                    chat.sender.name,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
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
                                                  trailing: Text(
                                                    chat.time,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w300,
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
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: whiteColor,
                  ),
                  child: isloadingFirstTime == false
                      ? Column(
                          children: <Widget>[
                            Expanded(
                              child: isLoading == true
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    )
                                  : userMessages.isNotEmpty
                                      ? ListView.builder(
                                          reverse: true,
                                          padding: const EdgeInsets.all(20),
                                          itemCount: userMessages.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final Message message =
                                                userMessages[index];
                                            final bool isMe =
                                                message.sender.id ==
                                                    currentUser.id;
                                            var prevUserId;
                                            final bool isSameUser =
                                                prevUserId == message.sender.id;
                                            prevUserId = message.sender.id;
                                            return _chatBubble(
                                                message, isMe, isSameUser);
                                          },
                                        )
                                      : const Center(
                                          child: Text("No messages found."),
                                        ),
                            ),
                            _sendMessageArea(),
                          ],
                        )
                      : const Center(
                          child: Text("Please select a chat from left window"),
                        ),
                ),
              ),
            ),

            // second half of page
          ],
        ),
      ),
    );
  }
}
