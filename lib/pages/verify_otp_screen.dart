// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:buzzapp/controller/web_api.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/constant.dart';
import '../responsive/desktop_body.dart';
import '../responsive/mobile_body.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/tablet_body.dart';
import 'dashboard_screen.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String emailAddress;
  static const routeName = '/verify-otp';
  const VerifyOTPScreen({super.key, required this.emailAddress});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  FocusNode? otpNode;
  late String otpString;
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    otpNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
    otpNode?.dispose();

    super.dispose();
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: whiteColor,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: primaryColor),
    ),
  );

  updateUI(var response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'userID', response['user']['User_ID'].toString());
    await sharedPreferences.setString(
        'first_name', response['user']['User_First_Name']);
    await sharedPreferences.setString(
        'last_name', response['user']['User_Last_Name']);
    await sharedPreferences.setString('email', response['user']['User_Email']);
    sharedPreferences.setString('socialType', 'Form');
    await sharedPreferences.setString(
        'profileImage', response['user']['Profile_Picture']);
    await EasyLoading.showSuccess('Sign In Successfully');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ResponsiveLayout(
        mobileBody: const MobileScaffold(),
        tabletBody: const TabletScaffold(),
        desktopBody: const DesktopScaffold(),
      );
    }));
  }

  void _submitOTP(String otp) {
    makeLogin(otp);
  }

  makeLogin(String otp) async {
    var getData = await WebConfig.verifyOTP(
        otp: otp, gcmID: 'Form', emailAddress: widget.emailAddress);
    if (getData['status'] == true) {
      updateUI(getData);
    } else {
      await EasyLoading.showError(getData['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [primaryColor, Colors.purple],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 7.5.h,
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
              height: 2.5.h,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4.5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.0.w, right: 7.0.w),
                        child: Text(
                          'Enter OTP',
                          textAlign: TextAlign.center,
                          textScaleFactor: kTextScaleFactor,
                          style: TextStyle(
                              fontFamily: 'DMSans',
                              color: blackColor,
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 3.5.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.5.w, right: 4.5.w),
                        child: Directionality(
                          // Specify direction if desired
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            controller: pinController,
                            focusNode: focusNode,
                            androidSmsAutofillMethod:
                                AndroidSmsAutofillMethod.smsRetrieverApi,
                            listenForMultipleSmsOnAndroid: true,
                            defaultPinTheme: defaultPinTheme,
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {
                              otpString = pin;
                            },
                            onChanged: (value) {},
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  width: 22,
                                  height: 1,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                            length: 6,
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(color: primaryColor),
                              ),
                            ),
                            submittedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(color: primaryColor),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyBorderWith(
                              border: Border.all(color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.5.h,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.5.w),
                          child: InkWell(
                            onTap: () {
                              // getSharedPreferences();
                            },
                            child: const Text(
                              'Resend OTP',
                              textAlign: TextAlign.center,
                              textScaleFactor: kTextScaleFactor,
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                // color: primaryColor,
                                color: transparentColor,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 100.0.w,
                        height: 55.0,
                        margin: EdgeInsets.only(
                          left: 5.5.w,
                          right: 5.5.w,
                        ),
                        child: ElevatedButton(
                          style: buttonStyle,
                          child: const Text(
                            "Verify and proceed",
                            textScaleFactor: kTextScaleFactor,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () async {
                            if (pinController.text.isEmpty) {
                              showSnackBar(
                                  bottom: 10.0.h,
                                  context: context,
                                  text: 'OTP Required');
                            } else {
                              _submitOTP(otpString);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 3.5.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
