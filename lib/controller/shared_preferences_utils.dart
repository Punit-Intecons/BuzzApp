import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/get_meta_details.dart';
import '../responsive/desktop_body.dart';
import '../responsive/mobile_body.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/tablet_body.dart';

Future<void> updateUI(BuildContext context, var response, var socialType, var dataFilled) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if(response!="" && response!=null) {
    await sharedPreferences.setString(
        'userID', response['user']['User_ID'].toString());
    await sharedPreferences.setString(
        'first_name', response['user']['User_First_Name']);
    await sharedPreferences.setString(
        'last_name', response['user']['User_Last_Name']);
    await sharedPreferences.setString('email', response['user']['User_Email']);
    sharedPreferences.setString('socialType', socialType);
    await sharedPreferences.setString(
        'profileImage', response['user']['Profile_Picture']);
    await sharedPreferences.setString(
        'phoneNo', response['user']['User_Mobile_No'] ?? '');
    await sharedPreferences.setString(
        'countryCode', (response['user']['Phone_Country_Code']!=""?response['user']['Phone_Country_Code'].toString():''));
    await sharedPreferences.setString(
        'WABA_ID', response['user']['WABA_ID'] ?? '');
    await sharedPreferences.setString(
        'Meta_Key', response['user']['Meta_Key'] ?? '');
    await EasyLoading.showSuccess('Sign In Successfully');
  }
  if(dataFilled!="") sharedPreferences.setString('metaKeysAvailable', dataFilled);
  if(dataFilled == 'No'){
    Navigator.pushNamed(context, UserMetaDetails.routeName);
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ResponsiveLayout(
        mobileBody: const MobileScaffold(),
        tabletBody: const TabletScaffold(),
        desktopBody: const DesktopScaffold(),
      );
    }));
  }
}
