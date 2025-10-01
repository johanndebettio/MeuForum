import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final _userRepo = UserRepository();

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username != null) {
      _user = await _userRepo.getUserByUsername(username);
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    final user = await _userRepo.authenticate(username, password);
    if (user != null) {
      _user = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', user.username);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _user = null;
    notifyListeners();
  }
}
