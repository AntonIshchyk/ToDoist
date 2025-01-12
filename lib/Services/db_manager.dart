import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  Database? _db;
  static final DBService _instance = DBService._internal();

  // Factory constructor to ensure only one instance of DBService
  factory DBService() {
    return _instance;
  }

  DBService._internal();

  // Lazy initialization for the database
  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDatabase();
    return _db!;
  }

  // Initialize the database and create the 'users' table if not exists
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // This method is called to create the database schema when it is first created
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }
}
