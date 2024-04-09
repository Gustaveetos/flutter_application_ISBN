import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Banco {
  static final Banco instance = Banco._();
  static Database? _database;
  Banco._();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDataBase();
    return _database!;
  }

  _initDataBase() async {
    String path = join(await getDatabasesPath(), 'meu_banco.db');
    //return await openDatabase(path, version: 1, onCreate: _onCreate);
    return await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int versaoAntiga, int versaoNova) async {
    if (versaoAntiga < 2) {
      await db.execute("ALTER TABLE user ADD COLUMN ultimo_login TEXT");
    }
  }

//
  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE user(
      usernome TEXT PRIMARY KEY,
      password TEXT
    )''');
  }
}
