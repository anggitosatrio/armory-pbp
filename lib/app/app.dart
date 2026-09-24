import 'package:flutter/material.dart';

import '../features/auth/auth_scope.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/screens/auth_gate.dart';
import 'theme/app_theme.dart';

class ArmoryApp extends StatefulWidget {
  const ArmoryApp({super.key});

  @override
  State<ArmoryApp> createState() => _ArmoryAppState();
}

class _ArmoryAppState extends State<ArmoryApp> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();

    _authController = AuthController();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: _authController,
      child: MaterialApp(
        title: 'ARMORY',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const AuthGate(),
      ),
    );
  }
}