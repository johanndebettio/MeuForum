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
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      if (username != null) {
        final user = await _userRepo
            .getUserByUsername(username)
            .timeout(const Duration(seconds: 3), onTimeout: () => null);
        if (user != null) {
          _user = user;
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar sessão: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<String?> login(String username, String password) async {
    try {
      final result = await _userRepo.authenticate(username, password);

      switch (result) {
        case 'user_not_found':
          return 'Usuário não encontrado.';
        case 'wrong_password':
          return 'Senha incorreta. Verifique e tente novamente.';
        case 'success':
          final user = await _userRepo.getUserByUsername(username);
          if (user != null) {
            _user = user;
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', user.username);
            notifyListeners();
            return null;
          }
          return 'Erro ao carregar dados do usuário.';
        default:
          return 'Erro desconhecido. Retorno: $result';
      }
    } catch (e) {
      debugPrint('Erro ao fazer login: $e');
      return 'Erro de conexão com o servidor.';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _user = null;
    notifyListeners();
  }
}
