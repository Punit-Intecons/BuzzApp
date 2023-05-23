import 'dart:io';
import 'package:buzzapp/pages/verify_otp_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_button.dart';
import 'package:buzzapp/components/my_textfield.dart';
import 'package:buzzapp/components/square_tile.dart';
import 'package:buzzapp/pages/login_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../controller/shared_preferences_utils.dart';
import '../controller/web_api.dart';
import '../controller/constant.dart';
import '../responsive/desktop_body.dart';
import '../responsive/mobile_body.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/tablet_body.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  scopes: <String>[
    'email',
  ],
);

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign-up';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  var firstnameController = TextEditingController();

  var lastnameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  late String emailString;
  late String firstNameString;
  late String lastNameString;
  late String passwordString;

  late SharedPreferences sharedPreferences;
  bool _error = false;
  late FocusNode emailFocusNode = FocusNode();
  late FocusNode passwordFocusNode = FocusNode();
  late FocusNode firstnameFocusNode = FocusNode();
  late FocusNode lastnameFocusNode = FocusNode();
  late FocusNode confirmPasswordFocusNode = FocusNode();
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    emailController = TextEditingController();
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
    _handleSignOut();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        debugPrint(_currentUser!.displayName);
        debugPrint(_currentUser!.photoUrl);
        debugPrint(_currentUser!.id);
        debugPrint(_currentUser!.email);
      }
      _currentUser!.authentication.then((result) {
        debugPrint(result.accessToken);
        EasyLoading.show();
        socialRegister(_currentUser!.displayName, _currentUser!.id,
            _currentUser!.email, _currentUser!.photoUrl);
      }).catchError((err) {});
    });
    _googleSignIn.signInSilently();
  }

  socialRegister(String? displayName, String? socialID, String? emailAddress,
      String? imageURL) async {
    String? token = await FirebaseMessaging.instance.getToken();
    List<String> finalName = displayName!.split(' ');

    String firstName = finalName[0];
    String lastName = finalName[1];

    var getData = await WebConfig.socialSignIn(
        emailString: emailAddress!,
        imageLink: imageURL!,
        passwordString: 'Deck141#',
        deviceToken: token!,
        socialType: 'Google',
        firstName: firstName,
        lastName: lastName,
        socialProfileID: socialID!);
    if (getData['status'] == true) {
      await EasyLoading.showSuccess('Sign In Successfully');
      updateUI(context, getData,'Google');
    } else {
      await EasyLoading.showError(getData['msg']);
    }
  }

  signUpWithApple(String? displayName, String? userIdentifierString,
      String? emailAddress) async {
    await EasyLoading.show();
    String? token = await FirebaseMessaging.instance.getToken();
    var getData = await WebConfig.registerWithApple(
      emailString: emailAddress!,
      fullNameString: displayName!,
      userIdentifier: userIdentifierString!,
      deviceToken: token!,
    );
    if (getData['status'] == true) {
      await EasyLoading.showSuccess('Sign In Successfully');
      updateUI(context, getData,'Apple');
    } else {
      await EasyLoading.showError(getData['msg']);
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  // sign user in method
  void signUpUser(BuildContext context) async {
    await EasyLoading.show();
    if (firstnameController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter first name');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(firstnameFocusNode);
      return;
    } else if (lastnameController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter last name');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(lastnameFocusNode);
      return;
    } else if (emailController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter email address');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(emailFocusNode);
      return;
    } else if (passwordController.text.isEmpty) {
      await EasyLoading.showInfo('Please enter password');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(passwordFocusNode);
      return;
    } else if (confirmPasswordController.text.isEmpty) {
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
      var getData = await WebConfig.signUp(
          emailString: emailController.text,
          passwordString: passwordController.text,
          firstNameString: firstnameController.text,
          lastNameString: lastnameController.text);
      if (getData['status'] == true) {
        await EasyLoading.showSuccess(getData['msg']);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VerifyOTPScreen(
            emailAddress: emailController.text,
            screenType: 'signUP'
          );
        }));
      } else {
        await EasyLoading.showError(getData['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.08),

                          const Text(
                            'Welcome To BuzzApp',
                            style: TextStyle(
                                color: blackColor,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.10),

                          // username textfield
                          MyTextField(
                              controller: firstnameController,
                              hintText: 'First Name',
                              obscureText: false,
                              error: _error,
                              focusNode: firstnameFocusNode),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          MyTextField(
                              controller: lastnameController,
                              hintText: 'Last Name',
                              obscureText: false,
                              error: _error,
                              focusNode: lastnameFocusNode),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          MyTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              error: _error,
                              focusNode: emailFocusNode),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          // password textfield
                          MyTextField(
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: true,
                              error: _error,
                              focusNode: passwordFocusNode),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          // password textfield
                          MyTextField(
                              controller: confirmPasswordController,
                              hintText: 'Confirm Password',
                              obscureText: true,
                              error: _error,
                              focusNode: confirmPasswordFocusNode),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),

                          MyButton(
                              onTap: () => signUpUser(context),
                              buttonText: "Sign Up",
                              buttonColor: primaryColor),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),

                          // or continue with
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: blackColor,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
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

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),

                          // google + apple sign in buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // google button
                              SquareTile(
                                imagePath: 'assets/google.png',
                                onTap: () {
                                  _handleSignOut();
                                  _handleSignIn();
                                },
                              ),

                              const SizedBox(width: 25),

                              // apple button
                              Platform.isIOS || Platform.isMacOS
                                  ? SquareTile(
                                      imagePath: 'assets/apple.png',
                                      onTap: () async {
                                        final credential = await SignInWithApple
                                            .getAppleIDCredential(
                                          scopes: [
                                            AppleIDAuthorizationScopes.email,
                                            AppleIDAuthorizationScopes.fullName,
                                          ],
                                        );

                                        signUpWithApple(
                                            '${credential.givenName} ${credential.familyName}',
                                            credential.userIdentifier,
                                            credential.email);
                                      },
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),

                          // not a member? register now
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already a member?',
                                style: TextStyle(color: blackColor),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
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
