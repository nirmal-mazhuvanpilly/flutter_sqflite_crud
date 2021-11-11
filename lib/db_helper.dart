import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_flutter/animal.dart';

class DbHelper {
  DbHelper._internal();
  static final DbHelper instance = DbHelper._internal();

  static const _databaseName = "animal_database.db";
  static const _databaseVersion = 1;

  static const _tableName = "animals";

  static const _id = "id";
  static const _name = "name";
  static const _age = "age";

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    const create =
        "CREATE TABLE $_tableName($_id INTEGER PRIMARY KEY, $_name TEXT NOT NULL, $_age TEXT NOT NULL)";
    await db.execute(create);
  }

  Future<void> insertIntoAnimals(Animal animal) async {
    Database? db = await database;
    await db!.insert(
      _tableName,
      animal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Animal>> getAnimals() async {
    Database? db = await database;

    final List<Map<String, dynamic>> maps = await db!.query(_tableName);

    // ignore: avoid_print
    print(maps);

    return List.generate(maps.length, (i) {
      return Animal(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateIntoAnimals(Animal animal,int id) async {
    Database? db = await database;
    await db!.update(_tableName, animal.toMap(),
        where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteFromAnimals() async {
    Database? db = await database;
    await db!.delete(_tableName,where: "name = ?",whereArgs: ["Test"]);
  }
}
