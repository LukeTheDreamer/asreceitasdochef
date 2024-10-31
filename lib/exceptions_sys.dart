// lib/exceptions/app_exception.dart
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

// lib/exceptions/auth_exception.dart


class AuthException extends AppException {
  AuthException(super.message, {super.code});

  factory AuthException.fromCode(String code) {
    String message;
    switch (code) {
      case 'user-not-found':
        message = 'Usuário não encontrado.';
        break;
      case 'wrong-password':
        message = 'Senha incorreta.';
        break;
      case 'email-already-in-use':
        message = 'Este email já está em uso.';
        break;
      default:
        message = 'Erro de autenticação.';
    }
    return AuthException(message, code: code);
  }
}

// lib/exceptions/exceptions.dart
