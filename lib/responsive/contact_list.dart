import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'chat_screen.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../controller/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/web_api.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
                        itemBuilder: (BuildContext context, int index) {
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
                              padding:
                                  const EdgeInsets.only(bottom: 4.0, top: 10),
                              child: ListTile(
                                title: Text(
                                  chat.sender.name,
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    chat.text,
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: Colors.black54,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(chat.sender.imageUrl),
                                  radius: 35,
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
                    const Divider(
                      color: blackColor,
                      indent: 185,
                    )
                  ],
                )
              : const Center(
                  child: Text("No Chats found."),
                ),
    );
  }
}
