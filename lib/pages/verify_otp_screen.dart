// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:buzzapp/pages/resetPassword.dart';
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

class VerifyOTPScreen extends StatefulWidget {
  final String emailAddress;
  final String screenType;
  static const routeName = '/verify-otp';
  const VerifyOTPScreen({super.key, required this.emailAddress,required this.screenType});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  FocusNode? otpNode;
  late String otpString;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  late String email;
  late String _screenType;
  Timer? _timer;
  int _countdown = 15;
  bool _timerInProgress = true;

  @override
  void initState() {
    otpNode = FocusNode();
    email = widget.emailAddress;
    startTimer();
    super.initState();
  }
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timerInProgress = false;
          _timer?.cancel();
        }
      });
    });
  }
  Future<void> resendOTP() async {
    var getData = await WebConfig.forgotPassword(
      emailString: email,
    );
    if (getData['status'] == true) {
      await EasyLoading.showSuccess('We have sent you verification mail. Please verify and set your password');
      setState(() {
        _countdown = 15;
        _timerInProgress = true;
      });
      startTimer();
    } else {
      await EasyLoading.showError(getData['msg']);
    }
  }
  void onTimerFinish() {
    // Call your API to expire the OTP
    // You can perform any necessary actions here
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
    print("IN");
    var getData = await WebConfig.verifyOTP(
        otp: otp, gcmID: 'Form', emailAddress: widget.emailAddress,screenType: widget.screenType);
    print(getData);
    if (getData['status'] == true) {
      if(widget.screenType == 'forgotScreen') {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ResetPasswordScreen(
              emailAddress: widget.emailAddress,
              otp: otp,
              screenType: widget.screenType
          );
        }));
      }
      else {
        updateUI(getData);
      }
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
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.075,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.0.w, right: 7.0.w),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double screenWidth = constraints.maxWidth;
                            double fontSize = screenWidth *
                                0.08; // Adjust this value as needed

                            return Text(
                              'Verification Code',
                              textAlign: TextAlign.center,
                              textScaleFactor: MediaQuery
                                  .of(context)
                                  .textScaleFactor,
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: blackColor,
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold
                              ),
                            );
                          }
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7.0.w, right: 7.0.w),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double screenWidth = constraints.maxWidth;
                            double fontSize = screenWidth * 0.04; // Adjust this value as needed

                            return Text(
                              'We have sent the verification code to your email address\n\n$email',
                              textAlign: TextAlign.center,
                              textScaleFactor: MediaQuery.of(context).textScaleFactor,
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                color: greyColor,
                                fontSize: fontSize,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
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
                              await EasyLoading.showError('OTP Required');
                            } else {
                              _submitOTP(otpString);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Visibility(
                        visible: _timerInProgress,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 7.0.w, right: 7.0.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        double screenWidth = constraints.maxWidth;
                                        double fontSize = screenWidth * 0.08; // Adjust this value as needed

                                        return Text(
                                          "Didn't receive the code? ",
                                          textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                          style: TextStyle(fontSize: fontSize, color: blackColor),
                                        );
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        double screenWidth = constraints.maxWidth;
                                        double fontSize = screenWidth * 0.08; // Adjust this value as needed

                                        return Text(
                                          'Resend in $_countdown sec',
                                          textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                          style: TextStyle(fontSize: fontSize, color: greyColor),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !_timerInProgress,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 7.0.w, right: 7.0.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        double screenWidth = constraints.maxWidth;
                                        double fontSize = screenWidth * 0.08; // Adjust this value as needed

                                        return Text(
                                          "Didn't receive the code? ",
                                          textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                          style: TextStyle(fontSize: fontSize, color: blackColor),
                                        );
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        double screenWidth = constraints.maxWidth;
                                        double fontSize = screenWidth * 0.08; // Adjust this value as needed

                                        return TextButton(
                                          onPressed: _timerInProgress ? null : resendOTP,
                                          child: Text(
                                            'Resend',
                                            textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                            style: TextStyle(
                                                fontSize: fontSize,
                                                color: primaryColor
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
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
