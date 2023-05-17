import 'package:buzzapp/controller/web_api.dart';
import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_button.dart';
import 'package:buzzapp/components/my_textfield.dart';
import 'package:buzzapp/components/square_tile.dart';
import 'package:buzzapp/pages/signup_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/constant.dart';

import 'dashboard_screen.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  late SharedPreferences sharedPreferences;

  late String emailString;

  late String passwordString;

  // sign user in method
  void signUserIn(BuildContext context) async {
    await EasyLoading.show();
    if (emailController.text.isEmpty) {
      await EasyLoading.showInfo('Email Address Required');
    } else if (passwordController.text.isEmpty) {
      await EasyLoading.showInfo('Password Required');
    } else {
      // await EasyLoading.show();
      var getData = await WebConfig.makeLogin(
          emailString: emailController.text,
          passwordString: passwordController.text,
          deviceToken: '123456');

      if (getData['status'] == true) {
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString(
            'userID', getData['user']['User_ID'].toString());
        sharedPreferences.setString(
            'first_name', getData['user']['User_First_Name']);
        sharedPreferences.setString(
            'last_name', getData['user']['User_Last_Name']);
        sharedPreferences.setString('email', getData['user']['User_Email']);
        sharedPreferences.setString('socialType', 'Form');
        sharedPreferences.setString(
            'profileImage', getData['user']['Profile_Picture']);
        await EasyLoading.showSuccess('Sign In Successfully');
        Navigator.pushNamed(context, DashboardScreen.routeName);

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
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                  color: primaryColor,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                const Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: blackColor),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                    onTap: () => signUserIn(context), buttonText: "Sign In",buttonColor: primaryColor),

                const SizedBox(height: 50),

                // or continue with
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: blackColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: blackColor),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // google + apple sign in buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(imagePath: 'assets/google.png'),

                    SizedBox(width: 25),

                    // apple button
                    SquareTile(imagePath: 'assets/apple.png')
                  ],
                ),

                const SizedBox(height: 25),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member?',
                      style: TextStyle(color: blackColor),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
