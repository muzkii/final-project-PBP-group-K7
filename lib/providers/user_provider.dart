import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  bool _isStaff = false;

  String get username => _username;
  bool get isStaff => _isStaff;

  void setUser(String username, bool isStaff) {
    _username = username;
    _isStaff = isStaff;
    notifyListeners();
  }
}