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
  late FocusNode emailNode;
  late FocusNode passwordNode;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    emailController = TextEditingController();
    emailNode = FocusNode();
    super.initState();
  }

  // sign user in method
  void forgotPassword(BuildContext context) async {
    await EasyLoading.show();
    if (emailController.text.isEmpty) {
      await EasyLoading.showInfo('Email Address Required');
    } else {
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
      // backgroundColor: whiteColor,
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
              child:Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)
                  ),
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        // logo
                        // Image.asset(
                        //   'assets/logo.png',
                        //   width: 202.px,
                        //   height: 100.px,
                        // ),
                        // const Icon(
                        //   Icons.password,
                        //   size: 100,
                        //   color: primaryColor,
                        // ),

                        // const SizedBox(height: 10),

                        // welcome back, you've been missed!
                        const Text(
                          'Forgot Password!',
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 130),

                        // username textfield
                        MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                        ),
                        const SizedBox(height: 50),

                        // sign in button
                        MyButton(
                            onTap: () => forgotPassword(context),
                            buttonText: "Send",
                            buttonColor: primaryColor),

                        const SizedBox(height: 150),

                        // not a member? register now
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
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
                                    ]
                                )
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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
