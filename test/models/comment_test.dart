import 'package:flutter_test/flutter_test.dart';
import 'package:meu_forum/models/comment.dart';

void main() {
  group('Comment Model Tests', () {
    test('Criar comentário com dados válidos', () {
      // Arrange & Act
      final comment = Comment(
        id: 1,
        postId: 1,
        userId: 1,
        content: 'Este é um comentário',
        createdAt: '2025-11-06T10:00:00Z',
        userDisplayName: 'Test User',
      );

      // Assert
      expect(comment.id, 1);
      expect(comment.postId, 1);
      expect(comment.userId, 1);
      expect(comment.content, 'Este é um comentário');
      expect(comment.userDisplayName, 'Test User');
    });

    test('Converter comentário para Map', () {
      // Arrange
      final comment = Comment(
        id: 1,
        postId: 1,
        userId: 1,
        content: 'Este é um comentário',
        createdAt: '2025-11-06T10:00:00Z',
      );

      // Act
      final map = comment.toMap();

      // Assert
      expect(map['id'], 1);
      expect(map['post_id'], 1);
      expect(map['user_id'], 1);
      expect(map['content'], 'Este é um comentário');
      expect(map['created_at'], '2025-11-06T10:00:00Z');
    });

    test('Criar comentário a partir de Map', () {
      // Arrange
      final map = {
        'id': 1,
        'post_id': 1,
        'user_id': 1,
        'content': 'Este é um comentário',
        'created_at': '2025-11-06T10:00:00Z',
        'userDisplayName': 'Test User',
      };

      // Act
      final comment = Comment.fromMap(map);

      // Assert
      expect(comment.id, 1);
      expect(comment.postId, 1);
      expect(comment.userId, 1);
      expect(comment.content, 'Este é um comentário');
      expect(comment.userDisplayName, 'Test User');
    });
  });
}
