import 'package:flutter/material.dart';
import 'package:minstagram/models/user.dart';
import 'package:minstagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User get getUser => _user!;
  final Authentication _authentication = Authentication();

  Future<void> refreshUser() async {
    User user = await _authentication.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
