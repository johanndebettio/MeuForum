import 'package:flutter_test/flutter_test.dart';
import 'package:meu_forum/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('Criar usuário com dados válidos', () {
      // Arrange & Act
      final user = User(
        id: 1,
        username: 'testuser',
        password: 'hashedpassword',
        displayName: 'Test User',
        createdAt: '2025-11-06T10:00:00Z',
      );

      // Assert
      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.displayName, 'Test User');
    });

    test('Converter usuário para Map', () {
      // Arrange
      final user = User(
        id: 1,
        username: 'testuser',
        password: 'hashedpassword',
        displayName: 'Test User',
        createdAt: '2025-11-06T10:00:00Z',
      );

      // Act
      final map = user.toMap();

      // Assert
      expect(map['id'], 1);
      expect(map['username'], 'testuser');
      expect(map['password'], 'hashedpassword');
      expect(map['display_name'], 'Test User');
      expect(map['created_at'], '2025-11-06T10:00:00Z');
    });

    test('Criar usuário a partir de Map', () {
      // Arrange
      final map = {
        'id': 1,
        'username': 'testuser',
        'password': 'hashedpassword',
        'display_name': 'Test User',
        'created_at': '2025-11-06T10:00:00Z',
      };

      // Act
      final user = User.fromMap(map);

      // Assert
      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.password, 'hashedpassword');
      expect(user.displayName, 'Test User');
      expect(user.createdAt, '2025-11-06T10:00:00Z');
    });

    test('Criar usuário sem ID (novo usuário)', () {
      // Arrange & Act
      final user = User(
        username: 'newuser',
        password: 'password123',
      );

      // Assert
      expect(user.id, isNull);
      expect(user.username, 'newuser');
    });
  });
}
