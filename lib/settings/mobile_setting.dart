import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/my_dropdown.dart';
import '../components/my_imageuplode.dart';
import '../components/my_textfield.dart';
import '../controller/constant.dart';
import '../controller/web_api.dart';

class MobileSetting extends StatefulWidget {
  const MobileSetting({Key? key}) : super(key: key);

  @override
  State<MobileSetting> createState() => _MobileSettingState();
}

class _MobileSettingState extends State<MobileSetting> {
  String buttonSelected = '';
  late SharedPreferences sharedPreferences;
  late String userID;
  late String userFirstName = '';
  late String email;
  late bool _error = false;
  late int _selectedIndex = 0;
  late String selectedCode = '91';
  List<DropdownMenuItem<String>> dropdownItems = [];
  bool isCountryCodeLoaded = false;

  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var emailController = TextEditingController();
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var mobileController = TextEditingController();
  var metaKeyController = TextEditingController();
  var wabaidController = TextEditingController();

  late FocusNode emailFocusNode = FocusNode();
  late FocusNode firstnameFocusNode = FocusNode();
  late FocusNode lastnameFocusNode = FocusNode();
  late FocusNode currentPasswordFocusNode = FocusNode();
  late FocusNode newPasswordFocusNode = FocusNode();
  late FocusNode confirmPasswordFocusNode = FocusNode();
  late FocusNode mobileFocusNode = FocusNode();

  File? _selectedImage;

  void setImage(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  void initState() {
    getSharedData();
    super.initState();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    emailController = TextEditingController();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    mobileController = TextEditingController();
    metaKeyController = TextEditingController();
    wabaidController = TextEditingController();

    emailFocusNode = FocusNode();
    firstnameFocusNode = FocusNode();
    lastnameFocusNode = FocusNode();
    currentPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    mobileFocusNode = FocusNode();
    dropdownItems = [];
    if (!isCountryCodeLoaded) {
      getCountryCode();
    }
    toggleSettingPage('info');
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    emailController = TextEditingController();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    mobileController = TextEditingController();

    emailFocusNode = FocusNode();
    firstnameFocusNode = FocusNode();
    lastnameFocusNode = FocusNode();
    currentPasswordFocusNode = FocusNode();
    newPasswordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    mobileFocusNode = FocusNode();
    metaKeyController = TextEditingController();
    wabaidController = TextEditingController();
    dropdownItems = [];
  }

  getSharedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString('userID')!;
      userFirstName =
          firstnameController.text = sharedPreferences.getString('first_name')!;
      lastnameController.text = sharedPreferences.getString('last_name')!;
      emailController.text = sharedPreferences.getString('email')!;
      mobileController.text = sharedPreferences.getString('phoneNo')! ?? '';
      selectedCode = (sharedPreferences.getString('countryCode') != ""
          ? sharedPreferences.getString('countryCode')
          : selectedCode)!;
      mobileController.text = sharedPreferences.getString('phoneNo')! ?? '';
      metaKeyController.text = sharedPreferences.getString('Meta_Key')! ?? '';
      wabaidController.text = sharedPreferences.getString('WABA_ID')! ?? '';
    });
  }

  void toggleSettingPage(type) {
    setState(() {
      buttonSelected = type;
    });
  }

  getCountryCode() async {
    var getData = await WebConfig.getCountryCode();
    if (getData['status'] == true) {
      var countries = getData['country'] as List<dynamic>;
      setState(() {
        dropdownItems = countries.map<DropdownMenuItem<String>>((country) {
          return DropdownMenuItem<String>(
            value: country['countryCode'],
            child: Text('+${country["countryCode"]}',
                overflow: TextOverflow.ellipsis),
          );
        }).toList();
        isCountryCodeLoaded = true;
      });
    }
  }

  void updateProfile(BuildContext context) async {
    await EasyLoading.show();
    if (firstnameController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter your firstname');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(firstnameFocusNode);
      return;
    } else if (lastnameController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter your lastname');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(lastnameFocusNode);
      return;
    } else if (emailController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter your email');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(emailFocusNode);
      return;
    } else {
      setState(() {
        _error = false;
      });
      var getData = await WebConfig.updateProfile(
          firstName: firstnameController.text,
          lastName: lastnameController.text,
          email: emailController.text,
          userID: userID,
          mobileNumber:
              mobileController.text != "" ? mobileController.text : '',
          countryCode: mobileController.text != "" ? selectedCode : '91',
          profileImage: _selectedImage);

      if (getData['status'] == true) {
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString(
            'first_name', firstnameController.text);
        await sharedPreferences.setString('last_name', lastnameController.text);
        await sharedPreferences.setString('email', emailController.text);
        await sharedPreferences.setString(
            'phoneNo', mobileController.text ?? '');
        await sharedPreferences.setString('countryCode', selectedCode ?? '');
        await EasyLoading.showSuccess('Profile details updated successfully');
      } else {
        await EasyLoading.showError(getData['msg']);
      }
    }
  }

  void changePassword(BuildContext context) async {
    await EasyLoading.show();
    if (currentPasswordController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter your current password');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(currentPasswordFocusNode);
      return;
    } else if (newPasswordController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter your new password');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(newPasswordFocusNode);
      return;
    } else if (confirmPasswordController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter your confirm password');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
      return;
    } else if (newPasswordController.text != confirmPasswordController.text) {
      await EasyLoading.showInfo(
          'Confirm password is different from the new password');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
      return;
    } else {
      setState(() {
        _error = false;
      });
      var getData = await WebConfig.updatePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
        userID: userID,
      );

      print(getData);
      if (getData['status'] == true) {
        await EasyLoading.showSuccess('Password changed successfully');
      } else {
        await EasyLoading.showError(getData['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawer = myDrawer(context, 'campaign');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: secondaryBackgroundColor,
        appBar: myAppBar,
        drawer: drawer,
        body: isCampaignLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : userCampaigns.isNotEmpty
                ? ListView.builder(
                    itemCount: userCampaigns.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Campaign campaigns = userCampaigns[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: GestureDetector(
                          onTap: () => {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  padding: const EdgeInsets.only(
                                    left: 20,
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
                                                campaigns.campaignName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            campaigns.time,
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
                                      Row(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "Size:${campaigns.size}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: successColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            campaigns.metaCampaignName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: successColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
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
                    child: Text("No Campaign found."),
                  ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: whiteColor,
        elevation: 0,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          // Call your corresponding methods based on the selected index
          switch (_selectedIndex) {
            case 0:
              toggleSettingPage('info');
              break;
            case 1:
              toggleSettingPage('passwordScreen');
              break;
            case 2:
              toggleSettingPage('metaDetails');
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.password_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: ''),
        ],
      ),
    );
  }
}
