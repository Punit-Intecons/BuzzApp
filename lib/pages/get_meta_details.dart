import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_button.dart';
import 'package:buzzapp/components/my_textfield.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/shared_preferences_utils.dart';
import '../controller/web_api.dart';
import '../controller/constant.dart';

class UserMetaDetails extends StatefulWidget {
  static const routeName = '/user-meta-details';
  const UserMetaDetails({super.key});

  @override
  State<UserMetaDetails> createState() => _UserMetaDetailsState();
}

class _UserMetaDetailsState extends State<UserMetaDetails> {
  // text editing controllers
  var metaKey = TextEditingController();
  var WABA_ID = TextEditingController();

  late FocusNode _metaKey = FocusNode();
  late FocusNode _WABA_ID = FocusNode();
  late SharedPreferences sharedPreferences;
  bool _error =false;
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
    });
  }
  // sign user in method
  void saveMetaDetails(BuildContext context) async {
    await EasyLoading.show();
    if (metaKey.text.isEmpty) {
      await EasyLoading.showInfo('Please enter your meta key');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(_metaKey);
      return;
    } else if (WABA_ID.text.isEmpty) {
      await EasyLoading.showInfo('Please enter WABA id');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(_WABA_ID);
      return;
    } else {
      setState(() {
        _error = false;
      });
      var getData = await WebConfig.saveMetaDetails(
          metaKey: metaKey.text,
          WABA_ID: WABA_ID.text,
          userID: userID,
          userName: userName,
      );
      print(getData);
      if (getData['status'] == true) {
        await EasyLoading.showSuccess('Data updated successfully');
        updateUI(context, '','Form','Filled');
      } else {
        await EasyLoading.showError(getData['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [primaryColor, Colors.purple],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 75.0, right: 75.0),
                child: Center(
                  child: Image.asset(
                    'assets/logo_white.png',
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.08),

                          const Text(
                            'Meta Details Form',
                            style: TextStyle(
                                color: blackColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.10),

                          // username textfield
                          MyTextField(
                              controller: metaKey,
                              hintText: 'Meta Key',
                              obscureText: false,
                              error: _error,
                              focusNode: _metaKey),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          MyTextField(
                              controller: WABA_ID,
                              hintText: 'WABA_ID',
                              obscureText: false,
                              error: _error,
                              focusNode: _WABA_ID),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),

                          MyButton(
                              onTap: () => saveMetaDetails(context),
                              buttonText: "Save Details",
                              buttonColor: primaryColor),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
