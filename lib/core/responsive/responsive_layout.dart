import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < AppBreakpoints.mobile) {
          return mobile;
        }

        if (width < AppBreakpoints.tablet) {
          return tablet;
        }

        return desktop;
      },
    );
  }
}