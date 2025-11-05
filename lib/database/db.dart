// ignore_for_file: avoid_print

import 'dart:io' show Platform;
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DB {
  DB._();

  static final DB instance = DB._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      print('Inicializando banco...');

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        print('Usando FFI para banco local...');
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'meu_forum.db');
      print('Caminho do banco: $path');

      final db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          print('Criando tabelas...');
          await _onCreate(db, version);
          print('Tabelas criadas com sucesso!');
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () async {
          print('Timeout abrindo banco. Tentando recriar...');
          await deleteDatabase(path);
          return openDatabase(path, version: 1, onCreate: _onCreate);
        },
      );

      print('Banco inicializado com sucesso!');
      return db;
    } catch (e, st) {
      print('Erro ao inicializar banco: $e');
      print(st);
      rethrow;
    }
  }

  Future<void> resetDatabase() async {
    final path = join(await getDatabasesPath(), 'meu_forum.db');
    print('Resetando banco de dados...');
    await deleteDatabase(path);
    _database = null;
    print('Banco resetado com sucesso.');
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute(_users);
      await db.execute(_posts);
      await db.execute(_comments);
      await db.execute(_favorites);
      await db.execute(_likes);
    } catch (e) {
      print('Erro ao criar tabelas: $e');
      rethrow;
    }
  }

  String get _users => '''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      display_name TEXT,
      created_at TEXT
    );
  ''';

  String get _posts => '''
    CREATE TABLE posts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      content TEXT,
      created_at TEXT,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  ''';

  String get _comments => '''
    CREATE TABLE comments(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      post_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      content TEXT NOT NULL,
      created_at TEXT,
      FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  ''';

  String get _favorites => '''
    CREATE TABLE favorites(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      post_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      created_at TEXT,
      UNIQUE(post_id, user_id),
      FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  ''';

  String get _likes => '''
    CREATE TABLE likes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      post_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      type INTEGER NOT NULL,
      created_at TEXT,
      UNIQUE(post_id, user_id),
      FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
  ''';
}
