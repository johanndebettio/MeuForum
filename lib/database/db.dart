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
        version: 3, // Incrementada a versão para adicionar gif_url em comments
        onCreate: (db, version) async {
          print('Criando tabelas...');
          await _onCreate(db, version);
          print('Tabelas criadas com sucesso!');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          print('Atualizando banco de $oldVersion para $newVersion');
          await _onUpgrade(db, oldVersion, newVersion);
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        // Verifica se a coluna profile_image_path já existe em users
        final usersColumns = await db.rawQuery('PRAGMA table_info(users)');
        final hasProfileImagePath = usersColumns.any((col) => col['name'] == 'profile_image_path');
        
        if (!hasProfileImagePath) {
          await db.execute('ALTER TABLE users ADD COLUMN profile_image_path TEXT');
          print('Coluna profile_image_path adicionada em users');
        } else {
          print('Coluna profile_image_path já existe em users');
        }
      } catch (e) {
        print('Erro ao adicionar coluna profile_image_path: $e');
      }

      try {
        // Verifica se a coluna image_path já existe em posts
        final postsColumns = await db.rawQuery('PRAGMA table_info(posts)');
        final hasImagePath = postsColumns.any((col) => col['name'] == 'image_path');
        
        if (!hasImagePath) {
          await db.execute('ALTER TABLE posts ADD COLUMN image_path TEXT');
          print('Coluna image_path adicionada em posts');
        } else {
          print('Coluna image_path já existe em posts');
        }
      } catch (e) {
        print('Erro ao adicionar coluna image_path: $e');
      }

      print('Upgrade para versão 2 concluído!');
    }

    if (oldVersion < 3) {
      try {
        // Verifica se a coluna gif_url já existe em comments
        final commentsColumns = await db.rawQuery('PRAGMA table_info(comments)');
        final hasGifUrl = commentsColumns.any((col) => col['name'] == 'gif_url');
        
        if (!hasGifUrl) {
          await db.execute('ALTER TABLE comments ADD COLUMN gif_url TEXT');
          print('Coluna gif_url adicionada em comments');
        } else {
          print('Coluna gif_url já existe em comments');
        }
      } catch (e) {
        print('Erro ao adicionar coluna gif_url: $e');
      }

      print('Upgrade para versão 3 concluído!');
    }
  }

  String get _users => '''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      display_name TEXT,
      created_at TEXT,
      profile_image_path TEXT
    );
  ''';

  String get _posts => '''
    CREATE TABLE posts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      content TEXT,
      created_at TEXT,
      image_path TEXT,
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
      gif_url TEXT,
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
