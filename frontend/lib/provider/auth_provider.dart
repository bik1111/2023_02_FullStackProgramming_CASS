import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _jwtToken;

  String? get jwtToken => _jwtToken;

  void setToken(String token) {
    _jwtToken = token;
    notifyListeners();
  }

  void clearToken() {
    _jwtToken = null;
    notifyListeners();
  }
}
