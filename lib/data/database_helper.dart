// Arquivo: lib/data/database_helper.dart - CORRIGIDO PARA DESKTOP
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import '../model/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Inicializar databaseFactory para desktop (Windows, Linux, macOS)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Inicializar FFI
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = join(await getDatabasesPath(), 'sm_hotel.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    
    // Inserir usuário admin padrão
    String hashedPassword = _hashPassword('123456');
    await db.insert('users', {
      'name': 'Admin Hotel',
      'email': 'admin@hotel.com',
      'password': hashedPassword,
      'phone': '(11) 99999-9999',
      'address': 'Rua Hotel, 123 - São Paulo, SP',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      final db = await database;
      String hashedPassword = _hashPassword(password);
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, hashedPassword],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return User(
          id: maps.first['id'].toString(),
          name: maps.first['name'],
          email: maps.first['email'],
          phone: maps.first['phone'],
          address: maps.first['address'],
        );
      }
      return null;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      final db = await database;
      
      // Verificar se o email já existe
      final List<Map<String, dynamic>> existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (existingUser.isNotEmpty) {
        print('Email já existe: $email');
        return false; // Email já existe
      }

      String hashedPassword = _hashPassword(password);
      
      await db.insert('users', {
        'name': name,
        'email': email,
        'password': hashedPassword,
        'phone': phone,
        'address': address,
        'created_at': DateTime.now().toIso8601String(),
      });

      print('Usuário registrado com sucesso: $email');
      return true;
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return false;
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );
      return maps.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar email: $e');
      return false;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('users');
      
      return List.generate(maps.length, (i) {
        return User(
          id: maps[i]['id'].toString(),
          name: maps[i]['name'],
          email: maps[i]['email'],
          phone: maps[i]['phone'],
          address: maps[i]['address'],
        );
      });
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      return [];
    }
  }

  Future<void> deleteUser(String email) async {
    try {
      final db = await database;
      await db.delete(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      print('Usuário deletado: $email');
    } catch (e) {
      print('Erro ao deletar usuário: $e');
    }
  }

  Future<void> closeDatabase() async {
    try {
      final db = await database;
      await db.close();
    } catch (e) {
      print('Erro ao fechar banco: $e');
    }
  }

  // Método para resetar o banco (útil para testes)
  Future<void> resetDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'sm_hotel.db');
      await deleteDatabase(path);
      _database = null;
      await database; // Recriar o banco
      print('Banco resetado com sucesso');
    } catch (e) {
      print('Erro ao resetar banco: $e');
    }
  }
}