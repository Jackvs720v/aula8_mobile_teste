// ui/widgets/auth/auth_provider.dart
import 'package:flutter/material.dart';
import '../../../model/user.dart';
import '../../../data/database_helper.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 500));

      User? user = await _dbHelper.loginUser(email, password);

      if (user == null) {
        _setError('Email ou senha incorretos');
        _setLoading(false);
        return false;
      }

      _currentUser = user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao fazer login: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simula delay de rede
      await Future.delayed(const Duration(milliseconds: 500));

      bool success = await _dbHelper.registerUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );

      if (!success) {
        _setError('Este email já está cadastrado');
        _setLoading(false);
        return false;
      }

      // Fazer login automático após cadastro
      User? user = await _dbHelper.loginUser(email, password);
      if (user != null) {
        _currentUser = user;
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Erro ao criar conta: $e');
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Método útil para desenvolvimento/debug
  Future<List<User>> getAllUsers() async {
    return await _dbHelper.getAllUsers();
  }

  // Método para resetar o banco (útil para desenvolvimento)
  Future<void> resetDatabase() async {
    await _dbHelper.resetDatabase();
    logout();
  }

  // Método para verificar se email existe (opcional)
  Future<bool> emailExists(String email) async {
    return await _dbHelper.emailExists(email);
  }

  // Método para excluir usuário (opcional)
  Future<void> deleteUser(String email) async {
    await _dbHelper.deleteUser(email);
    // Se o usuário deletado for o atual, fazer logout
    if (_currentUser?.email == email) {
      logout();
    }
    notifyListeners();
  }
}