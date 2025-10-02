class ValidationHelper {
  // Validação geral
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório.';
    }
    return null;
  }

  // Tamanho string
  static String? validateLength(
      String? value, String fieldName, int minLength, int maxLength) {
    if (value == null) return null;

    if (value.length < minLength) {
      return '$fieldName deve conter pelo menos $minLength caracteres.';
    }
    if (value.length > maxLength) {
      return '$fieldName deve conter no máximo $maxLength caracteres.';
    }
    return null;
  }

  // Nome Usuário
  static String? validateUsername(String? username) {
    final required = validateRequired(username, 'Nome de usuário');
    if (required != null) return required;

    final length = validateLength(username!, 'Nome de usuário', 3, 20);
    if (length != null) return length;

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Nome de usuário deve conter apenas letras, números e underscore.';
    }

    return null;
  }

  // Senha Usuario
  static String? validatePassword(String? password) {
    final required = validateRequired(password, 'Senha');
    if (required != null) return required;

    if (password!.length < 8) {
      return 'Senha deve conter pelo menos 8 caracteres.';
    }

    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$')
        .hasMatch(password)) {
      return 'Senha deve conter ao menos: 1 maiúscula, 1 minúscula, 1 número e 1 caractere especial';
    }

    return null;
  }

  // Nome Exibição Usuario
  static String? validateDisplayName(String? displayName) {
    final required = validateRequired(displayName, 'Nome de exibição');
    if (required != null) return required;

    final length = validateLength(displayName!, 'Nome de exibição', 2, 50);
    if (length != null) return length;

    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(displayName)) {
      return 'Nome de exibição deve conter apenas letras e espaços.';
    }

    return null;
  }

  // Título post
  static String? validatePostTitle(String? title) {
    final required = validateRequired(title, 'Título');
    if (required != null) return required;

    final length = validateLength(title!, 'Título', 5, 100);
    if (length != null) return length;

    return null;
  }

  // Conteúdo post
  static String? validatePostContent(String? content) {
    if (content != null && content.trim().isNotEmpty) {
      final length = validateLength(content, 'Conteúdo', 1, 5000);
      if (length != null) return length;
    }
    return null;
  }

  // Comentário post
  static String? validateCommentContent(String? content) {
    final required = validateRequired(content, 'Comentário');
    if (required != null) return required;

    final length = validateLength(content!, 'Comentário', 1, 500);
    if (length != null) return length;

    return null;
  }
}
