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
        if (value.lists == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: value.lists?.length,
          itemBuilder: (context, index) {
            var item = value.lists?.elementAt(index);
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    name: item?.name,
                    userName: item?.username,
                    email: item?.email,
                    profilePic: item?.profileImage,
                    street: item?.address?.street,
                    suite: item?.address?.suite,
                    city: item?.address?.city,
                    zipCode: item?.address?.zipcode,
                    lat: item?.address?.geo?.lat,
                    lng: item?.address?.geo?.lng,
                    phone: item?.phone,
                    website: item?.website,
                    companyName: item?.company?.name,
                    catchPhrase: item?.company?.catchPhrase,
                    bs: item?.company?.bs,
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
                          backgroundImage: NetworkImage(
                              value.lists?.elementAt(index).profileImage ??
                                  invalidImage),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value.lists?.elementAt(index).name ?? "",
                                style: const TextStyle(color: Colors.white)),
                            Text(value.lists?.elementAt(index).email ?? "",
                                style: const TextStyle(color: Colors.white)),
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
  final String? userName;
  final String? email;
  final String? profilePic;
  final String? street;
  final String? suite;
  final String? city;
  final String? zipCode;
  final String? lat;
  final String? lng;
  final String? phone;
  final String? website;
  final String? companyName;
  final String? catchPhrase;
  final String? bs;
  const ProfileScreen(
      {Key? key,
      this.name,
      this.userName,
      this.email,
      this.profilePic,
      this.street,
      this.suite,
      this.city,
      this.zipCode,
      this.lat,
      this.lng,
      this.phone,
      this.website,
      this.companyName,
      this.catchPhrase,
      this.bs})
      : super(key: key);

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
                style: const TextStyle(fontSize: 25, color: Colors.indigo),
              ),
              const SizedBox(height: 25),
              Fields(fieldName: "Username", field: userName),
              const SizedBox(height: 10),
              Fields(fieldName: "Email", field: email),
              const SizedBox(height: 10),
              Fields(fieldName: "Street", field: street),
              const SizedBox(height: 10),
              Fields(fieldName: "Suite", field: suite),
              const SizedBox(height: 10),
              Fields(fieldName: "City", field: city),
              const SizedBox(height: 10),
              Fields(fieldName: "Zip Code", field: zipCode),
              const SizedBox(height: 10),
              Fields(fieldName: "Lat", field: lat),
              const SizedBox(height: 10),
              Fields(fieldName: "Lng", field: lng),
              const SizedBox(height: 10),
              Fields(fieldName: "Phone", field: phone),
              const SizedBox(height: 10),
              Fields(fieldName: "Website", field: website),
              const SizedBox(height: 10),
              Fields(fieldName: "Company name", field: companyName),
              const SizedBox(height: 10),
              Fields(fieldName: "CatchPhrase", field: catchPhrase),
              const SizedBox(height: 10),
              Fields(fieldName: "BS", field: bs),
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
  static const TextStyle fieldStyle =
      TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(fieldName ?? "", style: fieldStyle),
                const Text(":", style: fieldStyle),
              ],
            ),
          ),
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(child: Text(field ?? "", style: fieldStyle)),
                ],
              ))
        ],
      ),
    );
  }
}
