import 'package:flutter/material.dart';

import '../auth_scope.dart';
import 'login_screen.dart';
import '../../../core/widgets/shell/armory_shell.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    if (auth.isAuthenticated) {
      return const ArmoryShell();
    }

    return const LoginScreen();
  }
}