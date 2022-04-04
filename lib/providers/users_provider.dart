import 'package:flutter/material.dart';
import "package:chat_app/models/user.dart";

class UsersProvider with ChangeNotifier {
  final List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  void addUser(User user) {
    _users.add((user));
    notifyListeners();
  }
}
