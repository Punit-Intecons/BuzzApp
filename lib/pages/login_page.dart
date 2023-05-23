import 'dart:async';
import 'dart:io';
import 'package:buzzapp/controller/web_api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:buzzapp/components/my_button.dart';
import 'package:buzzapp/components/my_textfield.dart';
import 'package:buzzapp/components/square_tile.dart';
import 'package:buzzapp/pages/signup_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../controller/constant.dart';
import '../controller/shared_preferences_utils.dart';
import 'forgot_password.dart';
import 'package:lottie/lottie.dart';
import 'dart:developer' as developer;

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId:'877984892350-v72ru5qjiollokejf2hms6rkjn8u7uht.apps.googleusercontent.com',

  scopes: <String>[
    'email',
  ],
);

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  static const routeName = '/sign-in';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  late SharedPreferences sharedPreferences;

  late String emailString;

  late String passwordString;

  GoogleSignInAccount? _currentUser;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool _error = false;
  // ConnectivityResult _connectionStatus = ConnectivityResult.none;
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _handleSignOut();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {}
      _currentUser!.authentication.then((result) {
        debugPrint(result.accessToken);
        EasyLoading.show();
        socialRegister(_currentUser!.displayName, _currentUser!.id,
            _currentUser!.email, _currentUser!.photoUrl ?? '');
      }).catchError((err) {});
    });
    _googleSignIn.signInSilently();
    super.initState();
    // initConnectivity();

    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    super.dispose();
  }

  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     developer.log('Couldn\'t check connectivity status', error: e);
  //     return;
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //
  //   return _updateConnectionStatus(result);
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   setState(() {
  //     _connectionStatus = result;
  //   });
  // }
  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  socialRegister(String? displayName, String? socialID, String? emailAddress,
      String? imageLink) async {
    String? token = await FirebaseMessaging.instance.getToken();
    List<String> finalName = displayName!.split(' ');

    String firstName = finalName[0];
    String lastName = finalName[1];

    var getData = await WebConfig.socialSignIn(
        emailString: emailAddress!,
        passwordString: 'Deck141#',
        deviceToken: token!,
        socialType: 'Google',
        imageLink: imageLink!,
        firstName: firstName,
        lastName: lastName,
        socialProfileID: socialID!);
    if (getData['status'] == true) {
      await EasyLoading.showSuccess('Sign In Successfully');
      updateUI(context, getData,'Google','Not Filled');
    } else {
      await EasyLoading.showError(getData['msg']);
    }
  }

  socialLoginWithApple(String? userIdentifierString) async {
    String? token = await FirebaseMessaging.instance.getToken();
    var getData = await WebConfig.signInWithApple(
        deviceToken: token!, userIdentifier: userIdentifierString!);
    if (getData['status'] == true) {
      await EasyLoading.showSuccess('Sign In Successfully');
      updateUI(context, getData,'Apple','Not Filled');
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

  // sign user in method
  void signUserIn(BuildContext context) async {
    await EasyLoading.show();
    if (emailController.text.isEmpty) {
      await EasyLoading.showInfo('Email Address Required');
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(emailFocusNode);
      return;
    } else if (passwordController.text.isEmpty) {
      await EasyLoading.showInfo('Password Required');
      passwordFocusNode.requestFocus();
      setState(() {
        _error = true;
      });
      FocusScope.of(context).requestFocus(passwordFocusNode);
      return;
    } else {
      setState(() {
        _error = false;
      });
      // await EasyLoading.show();
      var getData = await WebConfig.makeLogin(
          emailString: emailController.text,
          passwordString: passwordController.text,
          deviceToken: '123456');

      if (getData['status'] == true) {
        await EasyLoading.showSuccess('Sign In Successfully');
        updateUI(context, getData,'Form','Not Filled');
      } else {
        await EasyLoading.showError(getData['msg']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(_connectionStatus);
    return Scaffold(
      body:
          // : _connectionStatus == ConnectivityResult.none
          //     ? Container(
          //   alignment: Alignment.center,
          //   padding: const EdgeInsets.all(15.0),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       LottieBuilder.asset('assets/network_error.json'),
          //       SizedBox(height: MediaQuery
          //           .of(context)
          //           .size
          //           .height * 0.10),
          //       const Text(
          //         'No Connection Available',
          //         style: TextStyle(
          //             fontFamily: 'DMSans',
          //             color: blackColor,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // ):
          Stack(
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
                            'Welcome back you\'ve been missed!',
                            style: TextStyle(
                                color: blackColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.10),

                          // username textfield
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
                                  MediaQuery.of(context).size.height * 0.01),

                          // forgot password?
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()),
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),

                          // sign in button
                          MyButton(
                              onTap: () => signUserIn(context),
                              buttonText: "Sign In",
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
                                        socialLoginWithApple(
                                            credential.userIdentifier);
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
                                'Not a member?',
                                style: TextStyle(color: blackColor),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage()),
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
