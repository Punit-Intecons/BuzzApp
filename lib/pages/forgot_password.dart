import 'package:buzzapp/controller/web_api.dart';
import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_button.dart';
import 'package:buzzapp/components/my_textfield.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';
import '../responsive/desktop_body.dart';
import '../responsive/mobile_body.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/tablet_body.dart';
import 'login_page.dart';


// ignore: must_be_immutable
class ForgotPassword extends StatefulWidget {
  static const routeName = '/sign-in';
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // text editing controllers
  var emailController = TextEditingController();
  late String emailString;
  late FocusNode passwordNode;
  late SharedPreferences sharedPreferences;
  bool _error = false;
  final FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  // sign user in method
  void forgotPassword(BuildContext context) async {
    await EasyLoading.show();
    if (emailController.text.isEmpty) {
      await EasyLoading.showInfo('Email Address Required');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(emailFocusNode);
      return;
    } else {
      setState(() {
        _error = false;
      });
      var getData = await WebConfig.forgotPassword(
          emailString: emailController.text,
      );

      if (getData['status'] == true) {
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('email', getData['user']['User_Email']);
        await EasyLoading.showSuccess('We have sent you verification mail. Please verify and set your password');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ResponsiveLayout(
            mobileBody: const MobileScaffold(),
            tabletBody: const TabletScaffold(),
            desktopBody: const DesktopScaffold(),
          );
        }));

        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return const DashboardScreen();
        // }));
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
                          const Text(
                            'Forgot Password!',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height * 0.10),

                          // username textfield
                          MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                            error:_error,
                            focusNode: emailFocusNode
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                          // sign in button
                          MyButton(
                            onTap: () => forgotPassword(context),
                            buttonText: "Send",
                            buttonColor: primaryColor,
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height * 0.15),

                          // not a member? register now
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.arrow_circle_left_outlined,
                                      size: 24,
                                      color: primaryColor,
                                    ),
                                    Text(
                                      ' Go Back To Login',
                                      style: TextStyle(
                                        color: greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
