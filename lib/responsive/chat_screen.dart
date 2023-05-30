import 'package:flutter/material.dart';
import 'package:buzzapp/models/message_model.dart';
import 'package:buzzapp/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';
import '../controller/web_api.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chatwindow';
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> userMessages = [];
  bool isLoading = true;
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
      getUserMessages();
    });
  }

  getUserMessages() async {
    setState(() {
      isLoading = true;
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
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message..',
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                textAlignVertical: TextAlignVertical.center,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
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
                        itemBuilder: (BuildContext context, int index) {
                          final Message message = userMessages[index];
                          final bool isMe = message.sender.id == currentUser.id;
                          var prevUserId;
                          final bool isSameUser =
                              prevUserId == message.sender.id;
                          prevUserId = message.sender.id;
                          return _chatBubble(message, isMe, isSameUser);
                        },
                      )
                    : const Center(
                        child: Text("No messages found."),
                      ),
          ),
          _sendMessageArea(),
        ],
      ),
    );
  }
}
