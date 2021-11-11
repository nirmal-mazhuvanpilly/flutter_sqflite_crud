import 'package:flutter/material.dart';
import 'package:sqflite_flutter/animal.dart';
import 'package:sqflite_flutter/db_helper.dart';

class UpdateScreen extends StatefulWidget {
  final int? id;
  final String? name;
  final String? age;
  const UpdateScreen({this.id, this.age, this.name});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final DbHelper db = DbHelper.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  late Animal animal;

  updateToAnimal({required String name, required String age}) async {
    animal = Animal(name: name, age: age);
    // ignore: avoid_print
    print(animal);
    await db.updateIntoAnimals(animal, widget.id!);
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name!;
    ageController.text = widget.age!;
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.grey[350],
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Update animal name",
                  hintStyle: TextStyle(color: Colors.blue),
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            Container(
              color: Colors.grey[350],
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  hintText: "Update animal age",
                  hintStyle: TextStyle(color: Colors.blue),
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          ageController.text.isNotEmpty) {
                        updateToAnimal(
                            name: nameController.text, age: ageController.text);
                        Navigator.of(context).pop();
                      } else {
                        const showSnackBar = SnackBar(
                            content: Text("Animal name & age cannot be empty"));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(showSnackBar);
                      }
                    },
                    child: const Text("Update")))
          ],
        ),
      ),
    );
  }
}
