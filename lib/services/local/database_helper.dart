import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../core/local_constants.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  DatabaseHelper._internal();

  // static Database? _db;
  //
  //
  // Future<Database> get db async {
  //   if(_db != null){
  //     return _db!;
  //   }
  //   _db = await initDatabase();
  //   return _db!;
  // }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    // final path = '$databasesPath/notes.db';
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  _onCreate(Database database, int version) async {
    database.execute("CREATE TABLE $tableProductName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, image TEXT, price REAL, date TEXT)");
  }
}