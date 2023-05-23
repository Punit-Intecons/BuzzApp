import 'package:flutter/material.dart';

class ResponsiveCampaign extends StatelessWidget {
  static const routeName = '/campaigns';
  final Widget mobileCampaign;
  final Widget tabletCampaign;
  final Widget desktopCampaign;

  const ResponsiveCampaign({
    super.key,
    required this.mobileCampaign,
    required this.tabletCampaign,
    required this.desktopCampaign,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return mobileCampaign;
        } else if (constraints.maxWidth < 1100) {
          return tabletCampaign;
        } else {
          return desktopCampaign;
        }
      },
    );
  }
}
