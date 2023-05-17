import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color whiteColor = Color(0xFFFFFFFF);
const Color blackColor = Colors.black;
const Color primaryColor = Color(0XFF296EFF);
const Color successColor = Color(0XFF628776);
const Color errorColor = Color(0XFFD14241);
const Color transparentColor = Color(0x00000000);
const Color greyBlueColor = Color(0XFFB8B8D2);
const Color greyColor = Color(0XFFA4A4A4);
const Color backgroundColor = Color(0XFFF1F1FA);
var defaultBackgroundColor = Colors.grey[300];
var appBarColor = Colors.grey[900];

const String appName = 'BuzzApp';

const double kTextScaleFactor = 0.8;

var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

var myAppBar = AppBar(
  backgroundColor: appBarColor,
  title: Text(' '),
  centerTitle: false,
);
var drawerTextColor = TextStyle(
  color: Colors.grey[600],
);

const String kBaseURL = 'http://3.226.153.18/mlsapps/nAPI/BuzzAppApi/index.php';

showSnackBar(
    {required BuildContext context,
    required String text,
    required double bottom}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      style: const TextStyle(fontFamily: 'DMSans'),
    ),
    backgroundColor: errorColor,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: bottom, right: 20, left: 20),
    duration: const Duration(seconds: 2),
  ));
}

getSharedData() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? tokenString = sharedPreferences.getString('token');
  String? customerId = sharedPreferences.getString('userID');
  String? emailAddress = sharedPreferences.getString('email');
  String? socialType = sharedPreferences.getString('socialType');
  String? firstName = sharedPreferences.getString('first_name');
  String? lastName = sharedPreferences.getString('last_name');
  String? profileImage = sharedPreferences.getString('profileImage');
  var data = {
    "token": tokenString,
    "userID": customerId,
    "emailAddress": emailAddress,
    "socialType": socialType,
    "firstName": firstName,
    "lastName": lastName,
    "profileImage": profileImage,
  };
  return data;
}

ButtonStyle buttonStyle = ButtonStyle(
  alignment: Alignment.center,
  foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
  backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
  shadowColor: MaterialStateProperty.all<Color>(primaryColor),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      side: const BorderSide(color: Color(0XFF0d5e7c), width: 0.0),
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
);

showAlert(BuildContext buildContext) {
  showDialog<void>(
    context: buildContext,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text(
            'Exit from application',
            textScaleFactor: kTextScaleFactor,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontWeight: FontWeight.bold,
              fontSize: 18.0.sp,
            ),
          ),
          content: Text(
            'Are you sure?',
            textScaleFactor: kTextScaleFactor,
            style: TextStyle(fontFamily: 'DMSans', fontSize: 16.0.sp),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'No',
                style: TextStyle(fontFamily: 'DMSans', fontSize: 14.0.sp),
              ),
              onPressed: () {
                Navigator.pop(buildContext);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'Yes',
                style: TextStyle(fontFamily: 'DMSans', fontSize: 14.0.sp),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      } else {
        return AlertDialog(
          title: Text(
            'Exit from application',
            textScaleFactor: kTextScaleFactor,
            style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure?',
                  textScaleFactor: kTextScaleFactor,
                  style: TextStyle(fontFamily: 'DMSans', fontSize: 16.0.sp),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                textScaleFactor: kTextScaleFactor,
                style: TextStyle(
                    fontFamily: 'DMSans', fontSize: 16.0.sp, color: blackColor),
              ),
              onPressed: () {
                Navigator.pop(buildContext);
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                textScaleFactor: kTextScaleFactor,
                style: TextStyle(
                    fontFamily: 'DMSans', fontSize: 16.0.sp, color: blackColor),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      }
    },
  );
}

var myDrawer = Drawer(
  backgroundColor: Colors.grey[300],
  elevation: 0,
  child: Column(
    children: [
      const DrawerHeader(
        child: Icon(
          Icons.favorite,
          size: 64,
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: const Icon(Icons.message),
          title: Text(
            'I N B O X',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: const Icon(Icons.campaign),
          title: Text(
            'C A M P A I G N S',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: const Icon(Icons.contacts),
          title: Text(
            'C O N T A C T S',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: const Icon(Icons.analytics),
          title: Text(
            'A N A L Y T I C S',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: const Icon(Icons.logout),
          title: Text(
            'L O G O U T',
            style: drawerTextColor,
          ),
        ),
      ),
    ],
  ),
);
