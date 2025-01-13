import 'dart:async';
import '../Models/User.dart';
import '../Services/db_manager.dart';

class UserAccess {
  Future<int> insertUser(User user) async {
    final db = await DBService().database;
    final userMap = user.toMap();
    return await db.insert('users', userMap);
  }

  Future<List<User>> getUsers() async {
    final db = await DBService().database;

    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await DBService().database;

    final List<Map<String, dynamic>> result =
    await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int?> authenticateUser(String email, String password) async {
    final db = await DBService().database;

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await DBService().database;

    final userMap = user.toMap();

    return await db.update(
      'users',
      userMap,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await DBService().database;

    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
