import 'package:flutter/material.dart';
import 'package:sqflite_flutter/animal.dart';
import 'package:sqflite_flutter/db_helper.dart';

class AnimalProvider with ChangeNotifier {
  
  final DbHelper _db = DbHelper.instance;

  late Animal _animal;

  List<Animal> _dog = [];
  List<Animal> get dog => _dog;

  bool showList = false;

  changeShowList() {
    showList = !showList;
    notifyListeners();
  }

  insertToAnimal({required String name, required String age}) async {
    _animal = Animal(name: name, age: age);
    // ignore: avoid_print
    print(_animal);
    await _db.insertIntoAnimals(_animal);
    await fetchAnimals();
  }

  fetchAnimals() async {
    _dog = await _db.getAnimals();
    notifyListeners();
  }

  updateToAnimal(
      {required String name, required String age, required int id}) async {
    _animal = Animal(name: name, age: age);
    // ignore: avoid_print
    print(_animal);
    await _db.updateIntoAnimals(_animal, id);
    await fetchAnimals();
  }

  deleteAnimal({required int id}) async {
    await _db.deleteFromAnimals(id);
    await fetchAnimals();
  }
}
