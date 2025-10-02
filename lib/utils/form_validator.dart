import 'validation_helper.dart';

class FormValidator {
  final Map<String, String?> _errors = {};
  
  Map<String, String?> get errors => Map.unmodifiable(_errors);
  bool get hasErrors => _errors.values.any((error) => error != null);
  bool get isValid => !hasErrors;
  
  String? getError(String field) => _errors[field];
  
  void validateField(String field, String? value, String? Function(String?) validator) {
    _errors[field] = validator(value);
  }
  
  void clearError(String field) {
    _errors[field] = null;
  }
  
  void clearAllErrors() {
    _errors.clear();
  }
  
  // Validação para formulario de login, refistro, posts e comentarios
  void validateLoginForm(String username, String password) {
    validateField('username', username, (value) => ValidationHelper.validateRequired(value, 'Nome de usuário'));
    validateField('password', password, (value) => ValidationHelper.validateRequired(value, 'Senha'));
  }
  
  void validateRegisterForm(String username, String password, String displayName) {
    validateField('username', username, ValidationHelper.validateUsername);
    validateField('password', password, ValidationHelper.validatePassword);
    validateField('displayName', displayName, ValidationHelper.validateDisplayName);
  }
  
  void validatePostForm(String title, String? content) {
    validateField('title', title, ValidationHelper.validatePostTitle);
    validateField('content', content, ValidationHelper.validatePostContent);
  }
  
  void validateCommentForm(String content) {
    validateField('content', content, ValidationHelper.validateCommentContent);
  }
}