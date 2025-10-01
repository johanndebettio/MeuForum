import '../database/db.dart';
import 'package:sqflite/sqflite.dart';

class LikeDislikeRepository {
  final db = DB.instance;

  Future<void> likeDislike(int userId, int postId, int type) async {
    final database = await db.database;

    await database.insert(
      'likes',
      {
        'user_id': userId,
        'post_id': postId,
        'type': type,
        'created_at': DateTime.now().toIso8601String()
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getLikesCount(int postId) async {
    final database = await db.database;
    final result = await database.rawQuery(
        'SELECT SUM(type) as count FROM likes WHERE post_id = ?', [postId]);
    return result.first['count'] != null ? result.first['count'] as int : 0;
  }

  Future<int> getDislikesCount(int postId) async {
    final database = await db.database;
    final result = await database.rawQuery(
        'SELECT SUM(CASE WHEN type = -1 THEN 1 ELSE 0 END) as count FROM likes WHERE post_id = ?',
        [postId]);
    return result.first['count'] != null ? result.first['count'] as int : 0;
  }

  Future<int?> getUserReaction(int userId, int postId) async {
    final database = await db.database;
    final result = await database.query(
      'likes',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first['type'] as int;
  }

  Future<void> removeReaction(int userId, int postId) async {
    final database = await db.database;
    await database.delete(
      'likes',
      where: 'user_id = ? AND post_id = ?',
      whereArgs: [userId, postId],
    );
  }
}
