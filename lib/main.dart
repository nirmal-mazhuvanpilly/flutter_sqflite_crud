import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_flutter/contacts_provider.dart';

const invalidImage =
    "https://icons.iconarchive.com/icons/custom-icon-design/silky-line-user/512/user-man-invalid-icon.png";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ContactsProvider(),
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
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Future.microtask(() => context.read<ContactsProvider>().loadContacts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts from json to local database"),
      ),
      body: Consumer<ContactsProvider>(builder: (context, value, child) {
        if (value.lists?.contactList == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: value.lists?.contactList?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    profilePic:
                        value.lists?.contactList?.elementAt(index).profileImage,
                    name: value.lists?.contactList?.elementAt(index).name,
                    email: value.lists?.contactList?.elementAt(index).email,
                    city: value.lists?.contactList?.elementAt(index).address?.city,
                  ),
                ));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.indigo,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(value.lists?.contactList
                                  ?.elementAt(index)
                                  .profileImage ??
                              invalidImage),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value.lists?.contactList
                                    ?.elementAt(index)
                                    .name ??
                                ""),
                            Text(value.lists?.contactList
                                    ?.elementAt(index)
                                    .email ??
                                ""),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String? name;
  final String? profilePic;
  final String? email;
  final String? city;
  const ProfileScreen({
    Key? key,
    this.name,
    this.profilePic,
    this.email,
    this.city
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name ?? ""),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profilePic ?? invalidImage),
              ),
              Text(
                name ?? "",
                style: const TextStyle(fontSize: 25),
              ),
              Fields(fieldName: "Username", field: name),
              Fields(fieldName: "Email", field: email),
              Fields(fieldName: "City", field: city),
            ],
          ),
        ),
      ),
    );
  }
}

class Fields extends StatelessWidget {
  const Fields({Key? key, required this.field, required this.fieldName})
      : super(key: key);

  final String? fieldName, field;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fieldName!),
                Text(":"),
              ],
            ),
          ),
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Text(field ?? ""),
                ],
              ))
        ],
      ),
    );
  }
}
