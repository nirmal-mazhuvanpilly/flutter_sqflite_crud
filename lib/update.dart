import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_flutter/animal_provider.dart';

class UpdateScreen extends StatefulWidget {
  final int? id;
  final String? name;
  final String? age;
  // ignore: use_key_in_widget_constructors
  const UpdateScreen({this.id, this.age, this.name});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name!;
    _ageController.text = widget.age!;
  }

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
                controller: _nameController,
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
                controller: _ageController,
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
                      if (_nameController.text.isNotEmpty &&
                          _ageController.text.isNotEmpty) {
                        animalModel.updateToAnimal(name: _nameController.text, age: _ageController.text,id: widget.id!);
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
