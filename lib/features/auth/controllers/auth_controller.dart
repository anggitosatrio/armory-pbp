import 'package:flutter/foundation.dart';

import '../data/mock_user_repository.dart';
import '../models/user.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    MockUserRepository? repository,
  }) : _repository = repository ?? MockUserRepository();

  final MockUserRepository _repository;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final user = await _repository.login(
      email: email,
      password: password,
    );

    if (user == null) {
      _errorMessage = 'Invalid email or password';
      _setLoading(false);
      return false;
    }

    _currentUser = user;

    _setLoading(false);
    return true;
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}