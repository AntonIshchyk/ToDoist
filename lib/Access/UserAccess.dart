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
