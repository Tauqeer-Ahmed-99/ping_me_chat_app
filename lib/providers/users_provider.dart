import 'package:flutter/material.dart';
import "package:chat_app/models/user.dart";
import 'package:shared_preferences/shared_preferences.dart';

class UsersProvider with ChangeNotifier {
  final List<User> _users = [];

  var senderName;
  var senderNumber;

  Future<void> extractUsernameAndNumber() async {
    var prefs = await SharedPreferences.getInstance();

    senderName = prefs.getString("senderName") as String;
    senderNumber = prefs.getString("senderNumber") as String;
  }

  String get extractSenderName {
    extractUsernameAndNumber();
    print(senderName);
    return senderName;
  }

  String get extractSenderNumber {
    extractUsernameAndNumber();
    print(senderNumber);
    return senderName;
  }
}
