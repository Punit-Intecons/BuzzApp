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
import '../controller/web_api.dart';
import '../controller/constant.dart';
import '../responsive/desktop_body.dart';
import '../responsive/mobile_body.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/tablet_body.dart';
import 'dashboard_screen.dart';

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
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(
          'userID', getData['user']['User_ID'].toString());
      sharedPreferences.setString(
          'first_name', getData['user']['User_First_Name']);
      sharedPreferences.setString('socialType', 'Google');
      sharedPreferences.setString(
          'profileImage', getData['user']['Profile_Picture']);
      sharedPreferences.setString(
          'last_name', getData['user']['User_Last_Name']);
      sharedPreferences.setString('email', getData['user']['User_Email']);
      await EasyLoading.showSuccess('Sign In Successfully');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ResponsiveLayout(
          mobileBody: const MobileScaffold(),
          tabletBody: const TabletScaffold(),
          desktopBody: const DesktopScaffold(),
        );
      }));
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
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(
          'userID', getData['user']['User_ID'].toString());
      sharedPreferences.setString(
          'first_name', getData['user']['User_First_Name']);
      sharedPreferences.setString('socialType', 'Google');
      sharedPreferences.setString(
          'profileImage', getData['user']['Profile_Picture']);
      sharedPreferences.setString(
          'last_name', getData['user']['User_Last_Name']);
      sharedPreferences.setString('email', getData['user']['User_Email']);
      await EasyLoading.showSuccess('Sign In Successfully');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ResponsiveLayout(
          mobileBody: const MobileScaffold(),
          tabletBody: const TabletScaffold(),
          desktopBody: const DesktopScaffold(),
        );
      }));
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VerifyOTPScreen(
            emailAddress: emailController.text,
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    'Welcome To BuzzApp',
                    style: TextStyle(
                        color: blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
                      onTap: () => signUpUser(context),
                      buttonText: "Sign Up",
                      buttonColor: primaryColor),

                  const SizedBox(height: 50),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: const [
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
                                final credential =
                                    await SignInWithApple.getAppleIDCredential(
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

                  const SizedBox(height: 25),

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
                                builder: (context) => const LoginPage()),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
