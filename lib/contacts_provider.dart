import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_flutter/contacts.dart';
import 'package:sqflite_flutter/contacts_db_helper.dart';

class ContactsProvider with ChangeNotifier {
  final ContactsDbHelper _db = ContactsDbHelper.instance;

  List<Contacts>? _lists;

  List<Contacts>? get lists => _lists;

  set lists(List<Contacts>? lists) {
    _lists = lists;
    notifyListeners();
  }

  Future<String> _loadAsset(String asset) async {
    return await rootBundle.loadString('assets/$asset.json');
  }

  Future<void> insertToContacts(ContactsList? _lists) async {
    if (_lists?.contactList != null && _lists!.contactList!.isNotEmpty) {
      _lists.contactList?.forEach((element) async {
        await _db.insertIntoContacts(element);
      });
    }
    lists = await _db.getContacts();
    notifyListeners();
  }

  Future<void> loadContacts() async {
    lists = await _db.getContacts();

    if (lists == null || lists!.isEmpty) {
      String jsonString = await _loadAsset("contacts");
      final jsonResponse = json.decode(jsonString);
      ContactsList? lists = ContactsList.fromJson(jsonResponse);
      if (lists.contactList != null) {
        await insertToContacts(lists);
      }
    }
    notifyListeners();
  }
}
