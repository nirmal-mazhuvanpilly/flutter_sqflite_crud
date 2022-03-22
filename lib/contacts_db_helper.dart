import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_flutter/contacts.dart';

class ContactsDbHelper {
  ContactsDbHelper._internal();
  static final ContactsDbHelper instance = ContactsDbHelper._internal();

  static const _databaseName = "contacts_database.db";
  static const _databaseVersion = 1;

  static const _tableName = "contacts";

  static const _id = "id";
  static const _contact = "contact";

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
        "CREATE TABLE $_tableName($_id INTEGER PRIMARY KEY, $_contact TEXT NOT NULL)";
    await db.execute(create);
  }

  Future<void> insertIntoContacts(Contacts contact) async {
    var _contactValue = contact.toJson();
    String _data = jsonEncode(_contactValue);
    Map<String, dynamic> _insertValues = {"contact": _data};
    Database? db = await database;
    await db!.insert(
      _tableName,
      _insertValues,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Contacts>> getContacts() async {
    Database? db = await database;

    final List<Map<String, dynamic>> maps = await db!.query(_tableName);

    return List.generate(maps.length,
        (index) => Contacts.fromJson(jsonDecode(maps[index]["contact"])));
  }
}
