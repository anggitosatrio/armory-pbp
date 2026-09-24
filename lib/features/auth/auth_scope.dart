import 'package:flutter/material.dart';

import 'controllers/auth_controller.dart';

class AuthScope extends InheritedNotifier<AuthController> {
  const AuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();

    assert(
      scope != null,
      'AuthScope could not be found in the widget tree.',
    );

    return scope!.notifier!;
  }
}