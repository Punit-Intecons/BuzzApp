import 'package:flutter/material.dart';

class ResponsiveSettings extends StatelessWidget {
  static const routeName = '/settings';
  final Widget mobileSettings;
  final Widget tabletSettings;
  final Widget desktopSettings;

  const ResponsiveSettings({
    super.key,
    required this.mobileSettings,
    required this.tabletSettings,
    required this.desktopSettings,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return mobileSettings;
        } else if (constraints.maxWidth < 1100) {
          return tabletSettings;
        } else {
          return desktopSettings;
        }
      },
    );
  }
}
