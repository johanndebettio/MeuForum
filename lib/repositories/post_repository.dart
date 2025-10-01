import '../database/db.dart';
import '../models/post.dart';

class PostRepository {
  final db = DB.instance;

  Future<int> createPost(Post post) async {
    final database = await db.database;
    return await database.insert('posts', post.toMap());
  }

  Future<List<Post>> getAllPosts() async {
    final database = await db.database;
    final data = await database.rawQuery('''
    SELECT p.*, u.display_name as user_display_name
    FROM posts p
    JOIN users u ON p.user_id = u.id
    ORDER BY p.id DESC
  ''');
    return data.map((map) => Post.fromMap(map)).toList();
  }

  Future<List<Post>> getPostsByUser(int userId) async {
    final database = await db.database;
    final data = await database.rawQuery('''
    SELECT p.*, u.display_name as user_display_name
    FROM posts p
    JOIN users u ON p.user_id = u.id
    WHERE p.user_id = ?
    ORDER BY p.id DESC
  ''', [userId]);
    return data.map((map) => Post.fromMap(map)).toList();
  }

  Future<void> deletePost(int postId) async {
    final database = await db.database;
    await database.delete('posts', where: 'id = ?', whereArgs: [postId]);
  }
}
