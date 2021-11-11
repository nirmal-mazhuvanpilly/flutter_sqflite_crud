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
  final DbHelper db = DbHelper.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  List<Animal> dog = [];

  late Animal animal;

  bool showList = false;

  final TextStyle captionStyle = TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.bold);
  final TextStyle valueStyle = TextStyle(color: Colors.grey.shade800,fontWeight: FontWeight.bold);

  insertToAnimal({required String name, required String age}) async {
    animal = Animal(name: name, age: age);
    // ignore: avoid_print
    print(animal);
    await db.insertIntoAnimal(animal);
    await fetchAnimals();
  }

  fetchAnimals() async {
    dog = await db.animals();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
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
              controller: _ageController,
              decoration: const InputDecoration(
                hintText: "Enter Animal age",
                hintStyle: TextStyle(color: Colors.blue),
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  if (_ageController.text.isNotEmpty &&
                      _nameController.text.isNotEmpty) {
                    insertToAnimal(
                      name: _nameController.text,
                      age: _ageController.text,
                    );
                    _ageController.clear();
                    _nameController.clear();
                  } else {
                    const showSnackBar = SnackBar(
                        content: Text("Animal name & age cannot be empty"));
                    ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
                  }
                },
                child: const Text("Add Animal")),
          ),
          const SizedBox(height: 10),
          showList
              ? Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: ListView(
                      children: dog.map((data) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Name",style: captionStyle),
                                            Text(":",style: captionStyle),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(data.name,style: valueStyle),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Age",style: captionStyle),
                                            Text(":",style: captionStyle),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(data.age,style: valueStyle),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    await fetchAnimals();
                    setState(() {
                      showList = !showList;
                    });
                  },
                  child: const Text("Show List")),
        ],
      ),
    );
  }
}
