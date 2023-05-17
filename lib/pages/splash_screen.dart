import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/constant.dart';
import 'dashboard_screen.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('userID')) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const DashboardScreen();
        }));
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [whiteColor,primaryColor,whiteColor],
            stops: [0.0, 0.5,1],
          ),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/logo_white.png',
              width: 202.px,
              height: 216.px,
            ),
          ]),
        ),
      ),
    );
  }
}
