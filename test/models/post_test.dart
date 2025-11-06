import 'package:flutter_test/flutter_test.dart';
import 'package:meu_forum/models/post.dart';

void main() {
  group('Post Model Tests', () {
    test('Criar post com dados válidos', () {
      // Arrange & Act
      final post = Post(
        id: 1,
        userId: 1,
        title: 'Título do Post',
        content: 'Conteúdo do post',
        createdAt: '2025-11-06T10:00:00Z',
        userDisplayName: 'Test User',
      );

      // Assert
      expect(post.id, 1);
      expect(post.userId, 1);
      expect(post.title, 'Título do Post');
      expect(post.content, 'Conteúdo do post');
      expect(post.userDisplayName, 'Test User');
    });

    test('Converter post para Map', () {
      // Arrange
      final post = Post(
        id: 1,
        userId: 1,
        title: 'Título do Post',
        content: 'Conteúdo do post',
        createdAt: '2025-11-06T10:00:00Z',
      );

      // Act
      final map = post.toMap();

      // Assert
      expect(map['id'], 1);
      expect(map['user_id'], 1);
      expect(map['title'], 'Título do Post');
      expect(map['content'], 'Conteúdo do post');
      expect(map['created_at'], '2025-11-06T10:00:00Z');
    });

    test('Criar post a partir de Map', () {
      // Arrange
      final map = {
        'id': 1,
        'user_id': 1,
        'title': 'Título do Post',
        'content': 'Conteúdo do post',
        'created_at': '2025-11-06T10:00:00Z',
        'user_display_name': 'Test User',
      };

      // Act
      final post = Post.fromMap(map);

      // Assert
      expect(post.id, 1);
      expect(post.userId, 1);
      expect(post.title, 'Título do Post');
      expect(post.content, 'Conteúdo do post');
      expect(post.userDisplayName, 'Test User');
    });

    test('Criar post sem conteúdo (apenas título)', () {
      // Arrange & Act
      final post = Post(
        userId: 1,
        title: 'Apenas título',
      );

      // Assert
      expect(post.content, isNull);
      expect(post.title, 'Apenas título');
    });
  });
}
