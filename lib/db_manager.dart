import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Models/User.dart';

class DBManager {
  static final DBManager _instance = DBManager._internal();
  static Database? _database;

  DBManager._internal();

  factory DBManager() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

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
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  // Insert a User into the database
  Future<int> insertUser(User user) async {
    final db = await database;

    // Convert the User object to a map, excluding the 'id' (auto-generated)
    final userMap = {
      'name': user.name,
      'email': user.email,
      'password': user.password,
    };

    // Insert the user into the 'users' table and return the inserted row's id
    return await db.insert('users', userMap);
  }

  // Get all users from the database
  Future<List<User>> getUsers() async {
    final db = await database;

    // Query the 'users' table
    final List<Map<String, dynamic>> maps = await db.query('users');

    // Convert the List<Map> to List<User>
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Update a User in the database
  Future<int> updateUser(User user) async {
    final db = await database;

    // Convert the User object to a map, excluding the 'id'
    final userMap = {
      'name': user.name,
      'email': user.email,
      'password': user.password,
    };

    // Update the user in the database using the id as the identifier
    return await db.update(
      'users',
      userMap,
      where: 'id = ?',  // Don't update the id, use it only to locate the user
      whereArgs: [user.id],  // Pass the id as an argument to locate the user
    );
  }

  // Delete a User from the database
  Future<int> deleteUser(int id) async {
    final db = await database;

    // Delete the user from the database using the id
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
