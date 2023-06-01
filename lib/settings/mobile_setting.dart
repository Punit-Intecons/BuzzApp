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
    getSharedData();
    if (!isCountryCodeLoaded) {
      getCountryCode();
    }
    toggleSettingPage('info');
    super.initState();
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();

    emailFocusNode.dispose();
    firstnameFocusNode.dispose();
    lastnameFocusNode.dispose();
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    mobileFocusNode.dispose();
    metaKeyController.dispose();
    wabaidController.dispose();
    dropdownItems = [];
    isCountryCodeLoaded = false;

    super.dispose();
  }

  getSharedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      setState(() {
        userID = sharedPreferences.getString('userID') ?? '';
        userFirstName = firstnameController.text = sharedPreferences.getString('firstname') ?? '';
        lastnameController.text = sharedPreferences.getString('last_name') ?? '';
        emailController.text = sharedPreferences.getString('email') ?? '';
        mobileController.text = sharedPreferences.getString('phoneNo') ?? '';
        selectedCode = (sharedPreferences.getString('countryCode') != ""
            ? sharedPreferences.getString('countryCode')
            : selectedCode)!;
        mobileController.text = sharedPreferences.getString('phoneNo') ?? '';
        metaKeyController.text = sharedPreferences.getString('Meta_Key') ?? '';
        wabaidController.text = sharedPreferences.getString('WABA_ID') ?? '';
      });
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
      if (mounted) {
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
    var drawer = myDrawer(context, 'settings', userFirstName);
    return Scaffold(
      backgroundColor: secondaryBackgroundColor,
      appBar: myAppBar,
      drawer: drawer,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: buttonSelected == 'info'
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
                                    child: Text(
                                      'Profile Settings',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: greyColor,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
                                    child: Text(
                                      'Personal Information',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.w700,
                                        color: blackColor,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                                    child: Text(
                                      'Update your profile here',
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        color: greyColor,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 600),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03),
                                        ProfilePage(
                                            sizes: 100, setImage: setImage),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03),
                                        MyTextField(
                                          controller: firstnameController,
                                          hintText: 'First Name',
                                          obscureText: false,
                                          error: _error,
                                          focusNode: firstnameFocusNode,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03),
                                        MyTextField(
                                          controller: lastnameController,
                                          hintText: 'Last Name',
                                          obscureText: false,
                                          error: _error,
                                          focusNode: lastnameFocusNode,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03),
                                        MyTextField(
                                            controller: emailController,
                                            hintText: 'Email',
                                            obscureText: false,
                                            error: _error,
                                            focusNode: emailFocusNode),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                        Row(
                                          children: [
                                            MyDropdown(
                                              selectedCountryCode: selectedCode,
                                              list: dropdownItems,
                                              margin: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06),
                                              onValueChanged: (String value) {
                                                setState(() {
                                                  selectedCode = value;
                                                });
                                              },
                                            ),
                                            Expanded(
                                              child: MyTextField(
                                                controller: mobileController,
                                                hintText: 'Phone No.',
                                                obscureText: false,
                                                error: _error,
                                                focusNode: mobileFocusNode,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(18),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  updateProfile(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      primaryColor, // Set the background color to blue
                                                  minimumSize: const Size(100,
                                                      50), // Set the minimum width and height of the button
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Apply rounded corners
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]))
                        : buttonSelected == 'passwordScreen'
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 20, 0, 0),
                                            child: Text(
                                              'Password Settings',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.07,
                                                fontWeight: FontWeight.w700,
                                                color: primaryColor,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: greyColor,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 20, 0, 0),
                                            child: Text(
                                              'Change Password',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: FontWeight.w700,
                                                color: blackColor,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 8, 0, 0),
                                            child: Text(
                                              'You can update your password here',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                color: greyColor,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 600),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05),
                                                MyTextField(
                                                  controller:
                                                      currentPasswordController,
                                                  hintText: 'Current Password',
                                                  obscureText: true,
                                                  error: _error,
                                                  focusNode:
                                                      currentPasswordFocusNode,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                                MyTextField(
                                                  controller:
                                                      newPasswordController,
                                                  hintText: 'New Password',
                                                  obscureText: true,
                                                  error: _error,
                                                  focusNode:
                                                      newPasswordFocusNode,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                                MyTextField(
                                                    controller:
                                                        confirmPasswordController,
                                                    hintText:
                                                        'Confirm Password',
                                                    obscureText: true,
                                                    error: _error,
                                                    focusNode:
                                                        confirmPasswordFocusNode),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              18),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          changePassword(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              primaryColor, // Set the background color to blue
                                                          minimumSize: const Size(
                                                              100,
                                                              50), // Set the minimum width and height of the button
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8), // Apply rounded corners
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Change',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]))
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 20, 0, 0),
                                            child: Text(
                                              'Meta Information',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.07,
                                                fontWeight: FontWeight.w700,
                                                color: primaryColor,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04),
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: greyColor,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 20, 0, 0),
                                            child: Text(
                                              'Meta Details',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: FontWeight.w700,
                                                color: blackColor,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 8, 0, 0),
                                            child: Text(
                                              'You can view your meta details below',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                color: greyColor,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 600),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25.0),
                                                  child: TextField(
                                                      controller:
                                                          metaKeyController,
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        fillColor: Colors
                                                            .grey.shade200,
                                                        filled: true,
                                                        suffixIcon:
                                                            Icon(Icons.lock),
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25.0),
                                                  child: TextField(
                                                      controller:
                                                          wabaidController,
                                                      readOnly: true,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        fillColor: Colors
                                                            .grey.shade200,
                                                        filled: true,
                                                        suffixIcon:
                                                            Icon(Icons.lock),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]))),
              ),
            ),
          ],
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
