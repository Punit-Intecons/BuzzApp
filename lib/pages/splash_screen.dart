import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    checkLogin();
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  checkLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('userID')) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ResponsiveLayout(
            mobileBody: const MobileScaffold(),
            tabletBody: const TabletScaffold(),
            desktopBody: const DesktopScaffold(),
          );
        }));
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginPage();
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [primaryColor, Colors.purple],
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
