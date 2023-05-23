import 'package:buzzapp/controller/web_api.dart';
import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_button.dart';
import 'package:buzzapp/components/my_textfield.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';
import 'login_page.dart';


// ignore: must_be_immutable
class ResetPasswordScreen extends StatefulWidget {
  final String emailAddress;
  final String screenType;
  final String otp;
  static const routeName = '/reset-password';
  const ResetPasswordScreen({super.key, required this.emailAddress,required this.otp,required this.screenType});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  late String emailString;
  late FocusNode passwordNode;
  late SharedPreferences sharedPreferences;
  bool _error = false;
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    emailString = widget.emailAddress;
    super.initState();
  }

  // sign user in method
  void resetPassword(BuildContext context) async {
    await EasyLoading.show();
    if (passwordController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter password');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(passwordFocusNode);
      return;
    } else if(confirmPasswordController.text.isEmpty){
      await EasyLoading.showInfo('Please enter confirm password');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      await EasyLoading.showInfo(
          'Confirm password is different from the password');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
      return;
    } else {
      setState(() {
        _error = false;
      });
      var getData = await WebConfig.resetPassword(
        emailString: widget.emailAddress,
        otp: widget.otp,
        password: passwordController.text,
      );

      if (getData['status'] == true) {
        print(getData);
        await EasyLoading.showSuccess('Password is set successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        await EasyLoading.showError(getData['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.08),

                          // welcome back, you've been missed!
                          Padding(
                            padding: EdgeInsets.only(left: 7.0.w, right: 7.0.w),
                            child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double screenWidth = constraints.maxWidth;
                                  double fontSize = screenWidth *
                                      0.08; // Adjust this value as needed

                                  return Text(
                                    'Create New Password',
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
                                  'Please enter new password below.',
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

                          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                          // password textfield
                          MyTextField(
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: true,
                              error: _error,
                              focusNode: passwordFocusNode
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                          // password textfield
                          MyTextField(
                              controller: confirmPasswordController,
                              hintText: 'Confirm Password',
                              obscureText: true,
                              error: _error,
                              focusNode: confirmPasswordFocusNode
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                          MyButton(
                              onTap: () => resetPassword(context),
                              buttonText: "Reset",
                              buttonColor: primaryColor),

                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                          // not a member? register now
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => const LoginPage(),
                          //           ),
                          //         );
                          //       },
                          //       child: const Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Icon(
                          //             Icons.arrow_circle_left_outlined,
                          //             size: 24,
                          //             color: primaryColor,
                          //           ),
                          //           Text(
                          //             ' Go Back To Login',
                          //             style: TextStyle(
                          //               color: greyColor,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
