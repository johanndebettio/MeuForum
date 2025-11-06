import 'package:flutter_test/flutter_test.dart';
import 'package:meu_forum/utils/validation_helper.dart';

void main() {
  group('ValidationHelper Tests - Username', () {
    test('Username válido deve retornar null', () {
      // Arrange & Act
      final result = ValidationHelper.validateUsername('usuario123');

      // Assert
      expect(result, isNull);
    });

    test('Username muito curto deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateUsername('ab');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('pelo menos 3 caracteres'));
    });

    test('Username muito longo deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateUsername('a' * 21);

      // Assert
      expect(result, isNotNull);
      expect(result, contains('no máximo 20 caracteres'));
    });

    test('Username com caracteres especiais deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateUsername('user@123');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('letras, números e underscore'));
    });

    test('Username vazio deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateUsername('');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('obrigatório'));
    });
  });

  group('ValidationHelper Tests - Password', () {
    test('Senha válida deve retornar null', () {
      // Arrange & Act
      final result = ValidationHelper.validatePassword('Senha123!');

      // Assert
      expect(result, isNull);
    });

    test('Senha muito curta deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validatePassword('Sen1!');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('pelo menos 8 caracteres'));
    });

    test('Senha sem maiúscula deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validatePassword('senha123!');

      // Assert
      expect(result, isNotNull);
    });

    test('Senha sem minúscula deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validatePassword('SENHA123!');

      // Assert
      expect(result, isNotNull);
    });

    test('Senha sem número deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validatePassword('Senhaaa!');

      // Assert
      expect(result, isNotNull);
    });

    test('Senha sem caractere especial deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validatePassword('Senha123');

      // Assert
      expect(result, isNotNull);
    });
  });

  group('ValidationHelper Tests - Display Name', () {
    test('Nome de exibição válido deve retornar null', () {
      // Arrange & Act
      final result = ValidationHelper.validateDisplayName('João Silva');

      // Assert
      expect(result, isNull);
    });

    test('Nome muito curto deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateDisplayName('J');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('pelo menos 2 caracteres'));
    });

    test('Nome com números deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateDisplayName('João123');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('letras e espaços'));
    });

    test('Nome vazio deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateDisplayName('');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('obrigatório'));
    });
  });

  group('ValidationHelper Tests - Post Title', () {
    test('Título válido deve retornar null', () {
      // Arrange & Act
      final result = ValidationHelper.validatePostTitle('Título do meu post');

      // Assert
      expect(result, isNull);
    });

    test('Título muito curto deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validatePostTitle('Abc');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('pelo menos 5 caracteres'));
    });

    test('Título vazio deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validatePostTitle('');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('obrigatório'));
    });
  });

  group('ValidationHelper Tests - Comment Content', () {
    test('Comentário válido deve retornar null', () {
      // Arrange & Act
      final result = ValidationHelper.validateCommentContent('Ótimo post!');

      // Assert
      expect(result, isNull);
    });

    test('Comentário vazio deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateCommentContent('');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('obrigatório'));
    });

    test('Comentário muito longo deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateCommentContent('a' * 501);

      // Assert
      expect(result, isNotNull);
      expect(result, contains('no máximo 500 caracteres'));
    });
  });

  group('ValidationHelper Tests - Required Field', () {
    test('Campo preenchido deve retornar null', () {
      // Arrange & Act
      final result = ValidationHelper.validateRequired('valor', 'Campo');

      // Assert
      expect(result, isNull);
    });

    test('Campo vazio deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateRequired('', 'Campo');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('obrigatório'));
    });

    test('Campo null deve retornar erro', () {
      // Arrange & Act
      final result = ValidationHelper.validateRequired(null, 'Campo');

      // Assert
      expect(result, isNotNull);
      expect(result, contains('obrigatório'));
    });
  });
}
