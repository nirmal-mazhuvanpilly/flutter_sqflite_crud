import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_flutter/animal_provider.dart';
import 'package:sqflite_flutter/update.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AnimalProvider(),
    ),
  ], child: const MyApp()));
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  final TextStyle _captionStyle =
      TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold);
  final TextStyle _valueStyle =
      TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold);

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animalModel = Provider.of<AnimalProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Center(
            child: TextButton(
              child: const Text(
                "Show/Hide",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: animalModel.changeShowList,
            ),
          )
        ],
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
                hintText: "Enter animal name",
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
                hintText: "Enter animal age",
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
                    animalModel.insertToAnimal(
                        name: _nameController.text, age: _ageController.text);
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
          Provider.of<AnimalProvider>(context, listen: true).showList
              ? Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: Consumer<AnimalProvider>(
                      builder: (context, value, child) {
                        if (value.dog.isEmpty) {
                          return Center(
                            child: Text(
                              "No Animal Data !",
                              style: _captionStyle,
                            ),
                          );
                        }
                        return ListView(
                          children: value.dog.map((data) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 15,
                                    child: Text(data.id.toString()),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 280,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 50,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text("Name",
                                                          style: _captionStyle),
                                                      Text(":",
                                                          style: _captionStyle),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(data.name,
                                                    style: _valueStyle),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 50,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text("Age",
                                                          style: _captionStyle),
                                                      Text(":",
                                                          style: _captionStyle),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(data.age,
                                                    style: _valueStyle),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (_) =>
                                                        UpdateScreen(
                                                      id: data.id,
                                                      name: data.name,
                                                      age: data.age,
                                                    ),
                                                  ));
                                                },
                                                child: Text("Update",
                                                    style: _captionStyle)),
                                            IconButton(
                                                onPressed: () {
                                                  animalModel.deleteAnimal(
                                                      id: data.id!);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    child: Center(
                        child: Text(
                      "Show Animal List",
                      style: _captionStyle,
                    )),
                  ),
                ),
        ],
      ),
    );
  }
}
