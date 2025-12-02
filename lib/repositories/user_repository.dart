import 'package:bcrypt/bcrypt.dart';
import '../database/db.dart';
import '../models/user.dart';
import 'package:sqflite/sqflite.dart';

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

    try {
      return await database.insert('users', {
        'username': user.username,
        'password': hashed,
        'display_name': user.displayName,
        'created_at': user.createdAt ?? DateTime.now().toIso8601String(),
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw 'Nome de usuário já existe.';
      } else {
        throw 'Erro ao criar usuário.';
      }
    } catch (e) {
      throw 'Erro inesperado ao criar usuário: $e';
    }
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

  /// Atualiza a foto de perfil do usuário
  Future<void> updateProfileImage(int userId, String imagePath) async {
    final database = await db.database;
    await database.update(
      'users',
      {'profile_image_path': imagePath},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Atualiza os dados do usuário
  Future<void> updateUser(User user) async {
    final database = await db.database;
    await database.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
