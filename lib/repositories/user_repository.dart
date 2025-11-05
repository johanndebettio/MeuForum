import 'package:bcrypt/bcrypt.dart';
import '../database/db.dart';
import '../models/user.dart';

class UserRepository {
  final db = DB.instance;

  Future<int> createUser(User user) async {
    final database = await db.database;

    if (user.displayName == null || user.displayName!.trim().isEmpty) {
      throw Exception('Nome de exibição é obrigatório');
    }

    if (!_validatePassword(user.password)) {
      throw Exception(
          'Senha deve ter no mínimo 8 caracteres, incluindo maiúscula, minúscula, número e caractere especial');
    }

    final hashed = BCrypt.hashpw(user.password, BCrypt.gensalt());

    return await database.insert('users', {
      'username': user.username,
      'password': hashed,
      'display_name': user.displayName,
      'created_at': user.createdAt ?? DateTime.now().toIso8601String(),
    });
  }

  Future<User?> getUserByUsername(String username) async {
    final database = await db.database;
    final maps = await database.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<String> authenticate(String username, String password) async {
    final user = await getUserByUsername(username);
    if (user == null) return 'user_not_found';

    final ok = BCrypt.checkpw(password, user.password);
    if (!ok) return 'wrong_password';

    return 'success';
  }

  bool _validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
  }
}
