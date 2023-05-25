import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../campaign/desktop_campaign.dart';
import '../campaign/mobile_campaign.dart';
import '../campaign/responsive_campaign.dart';
import '../campaign/tablet_campaign.dart';
import '../pages/splash_screen.dart';
import '../responsive/desktop_body.dart';
import '../responsive/mobile_body.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/tablet_body.dart';
import '../settings/desktop_setting.dart';
import '../settings/mobile_setting.dart';
import '../settings/tablet_campaign.dart';

const Color whiteColor = Color(0xFFFFFFFF);
const Color iconColor = Color(0xFFFFFFFF);
const Color blackColor = Colors.black;
const Color primaryColor = Color(0XFF296EFF);
const Color successColor = Color(0XFF628776);
const Color errorColor = Color(0XFFD14241);
const Color transparentColor = Color(0x00000000);
const Color greyBlueColor = Color(0XFFB8B8D2);
const Color greyColor = Color(0XFFA4A4A4);
const Color backgroundColor = Color(0XFFF1F1FA);
const Color secondaryBackgroundColor = Color(0XFFF6F8FC);
var defaultBackgroundColor = Colors.grey[300];
const Color appBarColor = Color(0XFF296EFF);

const crsfToken = '3MUZqCyosJx8sALQ';

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
var drawerTextActiveColor = const TextStyle(
  color: iconColor,
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

showAlert(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      var buildContext = context;
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: const Text(
            'Are you sure',
            textScaleFactor: kTextScaleFactor,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          content: const Text(
            'You want to logout?',
            textScaleFactor: kTextScaleFactor,
            style: TextStyle(fontFamily: 'DMSans', fontSize: 18.0),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text(
                'No',
                style: TextStyle(fontFamily: 'DMSans', fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.pop(buildContext);
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                'Yes',
                style: TextStyle(fontFamily: 'DMSans', fontSize: 16.0),
              ),
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                await sharedPreferences.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SplashScreen();
                }));
              },
            ),
          ],
        );
      } else {
        return AlertDialog(
          title: const Text(
            'Are you sure',
            textScaleFactor: kTextScaleFactor,
            style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'You want to logout?',
                  textScaleFactor: kTextScaleFactor,
                  style: TextStyle(fontFamily: 'DMSans', fontSize: 18.0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                textScaleFactor: kTextScaleFactor,
                style: TextStyle(
                    fontFamily: 'DMSans', fontSize: 16.0, color: blackColor),
              ),
              onPressed: () {
                Navigator.pop(buildContext);
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                textScaleFactor: kTextScaleFactor,
                style: TextStyle(
                    fontFamily: 'DMSans', fontSize: 16.0, color: blackColor),
              ),
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                await sharedPreferences.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SplashScreen();
                }));
              },
            ),
          ],
        );
      }
    },
  );
}

Widget myDrawer(BuildContext context, String currentRouteName) {
  return Drawer(
    backgroundColor: whiteColor,
    elevation: 0,
    child: Column(
      children: [
        DrawerHeader(
          child: Image.asset(
            'assets/logo.png',
            width: 202.px,
            height: 216.px,
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            tileColor: currentRouteName == 'inbox' ? primaryColor : null,
            leading: Icon(
                Icons.message_outlined,
                color: currentRouteName == 'inbox' ? iconColor : null),
            title: Text(
              'I N B O X',
              style: currentRouteName == 'inbox' ? drawerTextActiveColor : drawerTextColor,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ResponsiveLayout(
                  mobileBody: MobileScaffold(),
                  tabletBody: TabletScaffold(),
                  desktopBody: DesktopScaffold(),
                );
              }));
            },
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            tileColor: currentRouteName == 'campaign' ? primaryColor : null,
            leading: Icon(
                Icons.campaign,
                color: currentRouteName == 'campaign' ? iconColor : null),
            title: Text(
              'C A M P A I G N S',
              style: currentRouteName == 'campaign' ? drawerTextActiveColor : drawerTextColor,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ResponsiveCampaign(
                  mobileCampaign: MobileCampaign(),
                  tabletCampaign: TabletCampaign(),
                  desktopCampaign: DesktopCampaign(),
                );
              }));
            },
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            tileColor: currentRouteName == 'contacts' ? primaryColor : null,
            leading: Icon(Icons.contacts,
            color: currentRouteName == 'contacts' ? iconColor : null),
            title: Text(
              'C O N T A C T S',
              style: currentRouteName == 'contacts' ? drawerTextActiveColor : drawerTextColor,
            ),
            onTap: () {
              // Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            tileColor: currentRouteName == 'analytics' ? primaryColor : null,
            leading: Icon(Icons.analytics,
                color: currentRouteName == 'analytics' ? iconColor : null),
            title: Text(
              'A N A L Y T I C S',
              style: currentRouteName == 'analytics' ? drawerTextActiveColor : drawerTextColor,
            ),
            onTap: () {
              // Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            tileColor: currentRouteName == 'settings' ? primaryColor : null,
            leading: Icon(Icons.settings,
                color: currentRouteName == 'settings' ? iconColor : null),
            title: Text(
              'S E T T I N G S',
              style: currentRouteName == 'settings' ? drawerTextActiveColor : drawerTextColor,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ResponsiveLayout(
                  mobileBody: MobileSetting(),
                  tabletBody: TabletSetting(),
                  desktopBody: DesktopSetting(),
                );
              }));
            },
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
            onTap: () {
              showAlert(context);
            },
          ),
        ),
      ],
    ),
  );
}
