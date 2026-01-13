import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Configuração para Desktop
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // --- ALTERAÇÃO AQUI ---
    // Usa ApplicationSupportDirectory (Recomendado para arquivos de dados da app)
    final Directory appSupportDir = await getApplicationSupportDirectory();

    // Garante que o diretório exista antes de criar o arquivo
    await appSupportDir.create(recursive: true);

    final String path = join(appSupportDir.path, 'urna_eletronica.db');

    // Debug: Mostra onde o banco está salvo no console
    print('Banco de dados da Urna localizado em: $path');
    // ----------------------

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Tabela TURMA
    await db.execute('''
      CREATE TABLE TURMA (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        SERIE INTEGER NOT NULL,
        LETRA TEXT NOT NULL,
        NIVEL TEXT NOT NULL CHECK(NIVEL IN ('Ensino Fundamental', 'Ensino Médio'))
      )
    ''');

    // 2. Tabela CANDIDATOS
    await db.execute('''
      CREATE TABLE CANDIDATOS (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        NOME TEXT NOT NULL,
        FOTO TEXT,
        STATUS INTEGER NOT NULL DEFAULT 1 -- 1 = Ativo, 0 = Inativo
      )
    ''');

    // 3. Tabela ELEICAO
    await db.execute('''
      CREATE TABLE ELEICAO (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        TITULO TEXT NOT NULL,
        ANO INTEGER NOT NULL,
        TOTAL_VOTOS INTEGER DEFAULT 0,
        STATUS INTEGER DEFAULT 1, -- 1 = Aberta, 0 = Finalizada
        FK_TURMA_ID INTEGER NOT NULL,
        FOREIGN KEY (FK_TURMA_ID) REFERENCES TURMA (ID) ON DELETE CASCADE
      )
    ''');

    // 4. Tabela ELEICAO_CANDIDATOS
    await db.execute('''
      CREATE TABLE ELEICAO_CANDIDATOS (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        FK_CANDIDATOS_ID INTEGER NOT NULL,
        FK_ELEICAO_ID INTEGER,
        QTD_VOTOS INTEGER DEFAULT 0,
        FOREIGN KEY (FK_CANDIDATOS_ID) REFERENCES CANDIDATOS (ID) ON DELETE RESTRICT,
        FOREIGN KEY (FK_ELEICAO_ID) REFERENCES ELEICAO (ID) ON DELETE SET NULL
      )
    ''');

    final batch = db.batch();

    // --- SEED DATA (Dados Iniciais) ---
    // Ensino Fundamental
    batch.insert('TURMA', {
      'SERIE': 1,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 2,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 3,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 3,
      'LETRA': 'B',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 4,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 4,
      'LETRA': 'B',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 5,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 5,
      'LETRA': 'B',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 6,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 6,
      'LETRA': 'B',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 7,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 7,
      'LETRA': 'B',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 8,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 8,
      'LETRA': 'B',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 9,
      'LETRA': 'A',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 9,
      'LETRA': 'B',
      'NIVEL': 'Ensino Fundamental',
    });
    batch.insert('TURMA', {
      'SERIE': 9,
      'LETRA': 'C',
      'NIVEL': 'Ensino Fundamental',
    });

    // Ensino Médio
    batch.insert('TURMA', {'SERIE': 1, 'LETRA': 'A', 'NIVEL': 'Ensino Médio'});
    batch.insert('TURMA', {'SERIE': 1, 'LETRA': 'B', 'NIVEL': 'Ensino Médio'});
    batch.insert('TURMA', {'SERIE': 1, 'LETRA': 'C', 'NIVEL': 'Ensino Médio'});
    batch.insert('TURMA', {'SERIE': 2, 'LETRA': 'A', 'NIVEL': 'Ensino Médio'});
    batch.insert('TURMA', {'SERIE': 2, 'LETRA': 'B', 'NIVEL': 'Ensino Médio'});
    batch.insert('TURMA', {'SERIE': 3, 'LETRA': 'A', 'NIVEL': 'Ensino Médio'});

    await batch.commit();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
