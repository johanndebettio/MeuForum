import '../database/db.dart';
import '../models/comment.dart';

class CommentRepository {
  final db = DB.instance;

  Future<List<Comment>> getCommentsByPost(int postId) async {
    final database = await db.database;
    final commentsData = await database.rawQuery('''
      SELECT c.id, c.post_id, c.user_id, c.content, c.created_at, c.gif_url, u.display_name as userDisplayName
      FROM comments c
      JOIN users u ON c.user_id = u.id
      WHERE c.post_id = ?
      ORDER BY c.id ASC
    ''', [postId]);

    return commentsData.map((map) => Comment.fromMap(map)).toList();
  }

  Future<void> createComment(Comment comment) async {
    final database = await db.database;
    await database.insert('comments', comment.toMap());
  }

  Future<void> deleteComment(int commentId, String username) async {
    final database = await db.database;

    final result = await database.query(
      'users',
      columns: ['display_name'],
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    final displayName =
        result.isNotEmpty ? result.first['display_name'] as String : username;

    await database.update(
      'comments',
      {'content': 'Comentário deletado por $displayName'},
      where: 'id = ?',
      whereArgs: [commentId],
    );
  }
}
