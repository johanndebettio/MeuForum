import '../database/db.dart';

class FavoriteRepository {
  final db = DB.instance;

  Future<void> favorite(int userId, int postId) async {
    final database = await db.database;
    await database.insert('favorites', {
      'user_id': userId,
      'post_id': postId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> unfavorite(int userId, int postId) async {
    final database = await db.database;
    await database.delete(
      'favorites',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }

  Future<bool> isFavorited(int userId, int postId) async {
    final database = await db.database;
    final result = await database.query(
      'favorites',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
    return result.isNotEmpty;
  }

  Future<List<int>> getFavoritePostIds(int userId) async {
    final database = await db.database;
    final data = await database.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return data.map((e) => e['post_id'] as int).toList();
  }
}
