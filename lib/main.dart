import 'package:buzzapp/campaign/responsive_campaign.dart';
import 'package:buzzapp/contacts/responsive_contacts.dart';
import 'package:buzzapp/responsive/desktop_body.dart';
import 'package:buzzapp/responsive/mobile_body.dart';
import 'package:buzzapp/responsive/responsive_layout.dart';
import 'package:buzzapp/responsive/tablet_body.dart';
import 'package:buzzapp/pages/get_meta_details.dart';
import 'package:buzzapp/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:buzzapp/pages/dashboard_screen.dart';
import 'package:buzzapp/pages/splash_screen.dart';
import 'package:buzzapp/pages/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'campaign/desktop_campaign.dart';
import 'campaign/mobile_campaign.dart';
import 'campaign/tablet_campaign.dart';
import 'contacts/desktop_contacts.dart';
import 'contacts/mobile_contacts.dart';
import 'contacts/tablet_contacts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
          LoginPage.routeName: (context) => const LoginPage(),
          SplashScreen.routeName: (context) => const SplashScreen(),
          DashboardScreen.routeName: (context) => const DashboardScreen(),
          VerifyOTPScreen.routeName: (context) =>
              const VerifyOTPScreen(emailAddress: '', screenType: ''),
          // ignore: equal_keys_in_map
          ResponsiveLayout.routeName: (context) => const ResponsiveLayout(
            mobileBody: MobileScaffold(),
            tabletBody: TabletScaffold(),
            desktopBody: DesktopScaffold(),
          ),
          ResponsiveCampaign.routeName: (context) => const ResponsiveCampaign(
            mobileCampaign: MobileCampaign(),
            tabletCampaign: TabletCampaign(),
            desktopCampaign: DesktopCampaign(),
          ),
          ResponsiveContacts.routeName: (context) => const ResponsiveContacts(
            mobileContacts: MobileContacts(),
            tabletContacts: TabletContacts(),
            desktopContacts: DesktopContacts(),
          ),
          UserMetaDetails.routeName: (context) => const UserMetaDetails(),
        },
      );
    });
  }
}
