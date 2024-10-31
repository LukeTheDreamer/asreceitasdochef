// lib/exceptions/auth_exception.dart
import 'app_exception.dart';

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
      case 'weak-password':
        message = 'A senha é muito fraca.';
        break;
      case 'invalid-email':
        message = 'Email inválido.';
        break;
      case 'user-disabled':
        message = 'Esta conta foi desativada.';
        break;
      case 'too-many-requests':
        message = 'Muitas tentativas. Tente novamente mais tarde.';
        break;
      case 'operation-not-allowed':
        message = 'Operação não permitida.';
        break;
      case 'requires-recent-login':
        message = 'Por favor, faça login novamente para continuar.';
        break;
      default:
        message = 'Erro de autenticação.';
    }
    return AuthException(message, code: code);
  }
}