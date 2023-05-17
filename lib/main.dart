import 'package:buzzapp/pages/dashboard_screen.dart';
import 'package:buzzapp/pages/splash_screen.dart';
import 'package:buzzapp/pages/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          DashboardScreen.routeName: (context) => const DashboardScreen(),
          VerifyOTPScreen.routeName: (context) =>
              const VerifyOTPScreen(emailAddress: ''),
        },
      );
    });
  }
}
