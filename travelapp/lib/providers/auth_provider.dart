import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String username, String password) async {
    bool success = await AuthService().login(username, password);
    if (success) {
      _currentUser = User(username: username, password: password);
      notifyListeners();
    }
    return success;
  }

  Future<bool> signup(String username, String password) async {
    bool success = await AuthService().signup(username, password);
    return success;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
