import 'package:buzzapp/pages/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_button.dart';
import 'package:buzzapp/components/my_textfield.dart';
import 'package:buzzapp/components/square_tile.dart';
import 'package:buzzapp/pages/login_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/web_api.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign-up';
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  final firstnameController = TextEditingController();

  final lastnameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  late String emailString;
  late String firstNameString;
  late String lastNameString;
  late String passwordString;

  late SharedPreferences sharedPreferences;

  // sign user in method
  void signUpUser(BuildContext context) async {
    await EasyLoading.show();
    if (firstnameController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter first name');
    } else if (lastnameController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter last name');
    } else if (emailController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter email address');
    } else if (passwordController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter password');
    } else if (confirmPasswordController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter confirm password');
    } else if (passwordController.text != confirmPasswordController.text) {
      await EasyLoading.showInfo(
          'Confirm password is different from the password');
    } else {
      var getData = await WebConfig.signUp(
          emailString: emailController.text,
          passwordString: passwordController.text,
          firstNameString: firstnameController.text,
          lastNameString: lastnameController.text);
      if (getData['status'] == true) {
        await EasyLoading.showSuccess(getData['msg']);
        Navigator.pushNamed(context, VerifyOTPScreen.routeName);
      } else {
        await EasyLoading.showError(getData['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Text(
                  'Welcome To BuzzApp',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: firstnameController,
                  hintText: 'First Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: lastnameController,
                  hintText: 'Last Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

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

                // password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                MyButton(
                    onTap: () => signUpUser(context), buttonText: "Sign Up"),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
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
