import 'package:flutter/material.dart';
import 'package:sqflite_flutter/db_helper.dart';
import 'package:sqflite_flutter/animal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Sqflite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbHelper db = DbHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  List<Animal> dog = [];

  late Animal animal;

  @override
  void initState() {
    super.initState();
    initializeDB();
  }

  initializeDB() async {
    await db.initializeDB();
    dog = await db.animals();
  }

  insertToAnimal({required String name, required String age}) async {
    animal = Animal(name: name, age: age);
    await db.insertIntoAnimal(animal);
    fetchAnimals();
  }

  fetchAnimals() async {
    dog = await db.animals();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.grey[350],
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Enter Animal name",
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
              controller: _ageController,
              decoration: const InputDecoration(
                hintText: "Enter Animal age",
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (_ageController.text.isNotEmpty &&
                    _nameController.text.isNotEmpty) {
                  insertToAnimal(
                    name: _nameController.text,
                    age: _ageController.text,
                  );
                } else {
                  const showSnackBar =
                      SnackBar(content: Text("Animal & age cannot be empty"));
                  ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
                }
              },
              child: const Text("Add Animal")),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: ListView(
                children: dog.map((data) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text("Name : "),
                            Text(data.name),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Age : "),
                            Text(data.age),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
