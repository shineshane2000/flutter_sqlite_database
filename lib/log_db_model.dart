import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LogDatabase {
  late Database database;

  Future<void> initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'log_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE LogDataSave (id	INTEGER,moduleName TEXT, type TEXT, message TEXT, time TEXT, PRIMARY KEY(id))",
        );
      },
      version: 1,
    );
  }


  Future<void> deleteAll() async{
    final Database db =  database;
    db.execute(
      "DELETE FROM LogDataSave",
    );
  }

  Future<int?> getCount()  async {
    final Database db =  database;

    return  Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM LogDataSave'));

  }


  Future<void> insertLog(LogDatabaseModel dog) async {
    final Database db =  database;

    await db.insert(
      'LogDataSave',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LogDatabaseModel>> selectAll() async {
    final Database db =  database;

    final List<Map<String, dynamic>> maps = await db.query('LogDataSave');

    return List.generate(maps.length, (i) {
      return LogDatabaseModel(
        id: maps[i]['id'],
        moduleName: maps[i]['moduleName'],
        type: maps[i]['type'],
        message: maps[i]['message'],
        time: maps[i]['time'],
      );
    });
  }

  Future<void> updateLog(LogDatabaseModel dog) async {
    final db =  database;

    await db.update(
      'LogDataSave',
      dog.toMap(),
      where: "id = ?",
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteLog(int id) async {
    final db =  database;

    await db.delete(
      'LogDataSave',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

class LogDatabaseModel {
  final int id;
  final String moduleName;
  final String type;
  final String message;
  final String time;


  LogDatabaseModel({required this.id, required this.moduleName, required this.type, required this.message, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moduleName': moduleName,
      'type': type,
      'message': message,
      'time': time,
    };
  }
}
