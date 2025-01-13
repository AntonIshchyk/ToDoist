import 'dart:async';
import '../Services/db_manager.dart';
import '../Models/Task.dart';

class TaskAccess {
  final DBService _dbService = DBService();

  Future<int> insertTask(Task task) async {
    final db = await _dbService.database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks(int userId) async {
    final db = await _dbService.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId]
    );

    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await _dbService.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int? id) async {
    final db = await _dbService.database;
    return db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
