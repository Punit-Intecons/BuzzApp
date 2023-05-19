import 'package:buzzapp/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

void signUserOut(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.clear();
  // ignore: use_build_context_synchronously
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return const SplashScreen();
  }));
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => signUserOut(context),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Text("Logged In"),
      ),
    );
  }
}
