import 'package:flutter/material.dart';

class ResponsiveContacts extends StatelessWidget {
  static const routeName = '/contacts';
  final Widget mobileContacts;
  final Widget tabletContacts;
  final Widget desktopContacts;

  const ResponsiveContacts({
    super.key,
    required this.mobileContacts,
    required this.tabletContacts,
    required this.desktopContacts,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return mobileContacts;
        } else if (constraints.maxWidth < 1100) {
          return tabletContacts;
        } else {
          return desktopContacts;
        }
      },
    );
  }
}
