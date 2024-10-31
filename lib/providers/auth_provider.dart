// lib/providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:receitas_do_chef/auth_exception.dart';
import 'package:receitas_do_chef/services/firebase_service.dart';


enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  AuthProvider({required FirebaseService firebaseService})
      : _firebaseService = firebaseService {
    // Listen to auth state changes
    _firebaseService.authStateChanges.listen((User? user) {
      _user = user;
      _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Stream<User?> get authStateChanges => _firebaseService.authStateChanges;

  // Login
  Future<void> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      await _firebaseService.signInWithEmailAndPassword(
        email.trim(),
        password.trim(),
      );

      _status = AuthStatus.authenticated;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      throw AuthException.fromCode(e.code);
    } catch (e) {
      _status = AuthStatus.error;
      throw AuthException('Erro inesperado ao fazer login');
    } finally {
      _setLoading(false);
    }
  }

  // Signup
  Future<void> signup(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final userCredential = await _firebaseService.createUserWithEmailAndPassword(
        email.trim(),
        password.trim(),
      );

      await _createUserDocument(userCredential.user!.uid, email);
      _status = AuthStatus.authenticated;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      throw AuthException.fromCode(e.code);
    } catch (e) {
      _status = AuthStatus.error;
      throw AuthException('Erro inesperado ao criar conta');
    } finally {
      _setLoading(false);
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(String uid, String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw AuthException('Erro ao criar perfil do usuário');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _firebaseService.signOut();
      _status = AuthStatus.unauthenticated;
      _user = null;
    } catch (e) {
      throw AuthException('Erro ao fazer logout');
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}