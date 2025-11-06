import 'package:flutter_test/flutter_test.dart';
import 'package:meu_forum/utils/form_validator.dart';

void main() {
  group('FormValidator Tests', () {
    late FormValidator validator;

    setUp(() {
      validator = FormValidator();
    });

    test('Validação de login válida', () {
      // Arrange & Act
      validator.validateLoginForm('usuario123', 'senha123');

      // Assert
      expect(validator.isValid, isTrue);
      expect(validator.hasErrors, isFalse);
    });

    test('Validação de login com username vazio', () {
      // Arrange & Act
      validator.validateLoginForm('', 'senha123');

      // Assert
      expect(validator.isValid, isFalse);
      expect(validator.hasErrors, isTrue);
      expect(validator.getError('username'), isNotNull);
    });

    test('Validação de login com senha vazia', () {
      // Arrange & Act
      validator.validateLoginForm('usuario123', '');

      // Assert
      expect(validator.isValid, isFalse);
      expect(validator.hasErrors, isTrue);
      expect(validator.getError('password'), isNotNull);
    });

    test('Validação de registro válida', () {
      // Arrange & Act
      validator.validateRegisterForm('usuario123', 'Senha123!', 'João Silva');

      // Assert
      expect(validator.isValid, isTrue);
      expect(validator.hasErrors, isFalse);
    });

    test('Validação de registro com username inválido', () {
      // Arrange & Act
      validator.validateRegisterForm('us', 'Senha123!', 'João Silva');

      // Assert
      expect(validator.isValid, isFalse);
      expect(validator.getError('username'), isNotNull);
    });

    test('Validação de registro com senha fraca', () {
      // Arrange & Act
      validator.validateRegisterForm('usuario123', 'senha', 'João Silva');

      // Assert
      expect(validator.isValid, isFalse);
      expect(validator.getError('password'), isNotNull);
    });

    test('Validação de post válida', () {
      // Arrange & Act
      validator.validatePostForm('Título do Post', 'Conteúdo do post');

      // Assert
      expect(validator.isValid, isTrue);
      expect(validator.hasErrors, isFalse);
    });

    test('Validação de post com título muito curto', () {
      // Arrange & Act
      validator.validatePostForm('abc', 'Conteúdo do post');

      // Assert
      expect(validator.isValid, isFalse);
      expect(validator.getError('title'), isNotNull);
    });

    test('Validação de comentário válido', () {
      // Arrange & Act
      validator.validateCommentForm('Este é um comentário válido');

      // Assert
      expect(validator.isValid, isTrue);
      expect(validator.hasErrors, isFalse);
    });

    test('Validação de comentário vazio', () {
      // Arrange & Act
      validator.validateCommentForm('');

      // Assert
      expect(validator.isValid, isFalse);
      expect(validator.getError('content'), isNotNull);
    });

    test('Limpar erro de um campo específico', () {
      // Arrange
      validator.validateLoginForm('', '');
      expect(validator.getError('username'), isNotNull);

      // Act
      validator.clearError('username');

      // Assert
      expect(validator.getError('username'), isNull);
    });

    test('Limpar todos os erros', () {
      // Arrange
      validator.validateLoginForm('', '');
      expect(validator.hasErrors, isTrue);

      // Act
      validator.clearAllErrors();

      // Assert
      expect(validator.hasErrors, isFalse);
      expect(validator.isValid, isTrue);
    });
  });
}
