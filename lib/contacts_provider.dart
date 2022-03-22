import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_flutter/contacts.dart';
import 'package:sqflite_flutter/contacts_db_helper.dart';

class ContactsProvider with ChangeNotifier {
  final ContactsDbHelper _db = ContactsDbHelper.instance;

  ContactsList? _lists;

  ContactsList? get lists => _lists;

  set lists(ContactsList? lists) {
    _lists = lists;
    notifyListeners();
  }

  Future<String> _loadAsset(String asset) async {
    return await rootBundle.loadString('assets/$asset.json');
  }

  Future<void> insertToContacts(ContactsList? lists) async {
    if (lists?.contactList != null && lists!.contactList!.isNotEmpty) {
      lists.contactList?.forEach((element) async {
        await _db.insertIntoContacts(element);
      });
    }
  }

  Future<void> loadContacts() async {
    lists?.contactList = await _db.getContacts();

    if (lists?.contactList == null) {
      String jsonString = await _loadAsset("contacts");
      final jsonResponse = json.decode(jsonString);
      lists = ContactsList.fromJson(jsonResponse);
      if (lists?.contactList != null) {
        await insertToContacts(lists);
      }
    }
    notifyListeners();
  }
}
