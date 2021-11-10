import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_flutter/animal.dart';

class DbHelper {
  static final DbHelper _dbSingleton = DbHelper._internal();
  factory DbHelper() {
    return _dbSingleton;
  }
  DbHelper._internal();

  late Database database;

  Future<void> initializeDB() async {
    const create =
        "CREATE TABLE animals(id INTEGER PRIMARY KEY, name TEXT, age TEXT)";
    final path = await getDatabasesPath();
    database = await openDatabase(
      join(path, 'animal_database.db'),
      onCreate: (db, version) {
        return db.execute(create);
      },
      version: 1,
    );
  }

  Future<void> insertIntoAnimal(Animal animal) async {
    final db = database;
    await db.insert(
      'animals',
      animal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Animal>> animals() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('animals');

    return List.generate(maps.length, (i) {
      return Animal(
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }
}
