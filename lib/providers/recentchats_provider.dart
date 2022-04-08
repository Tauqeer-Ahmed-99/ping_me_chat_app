// ignore: file_names
import 'package:flutter/cupertino.dart';

class RecentChats with ChangeNotifier {
  final _recentChats = [
    {
      "name": "Tauqeer",
      "lastMessage":
          "salam kidr jaa rha hai main kl aauga pdhne k liye tu bhi aajaana smjha kya wrna mera dimaag kharaab ho jaayega.",
      "date": DateTime.now(),
      "isRead": false,
      "numberOfNewMessages": 23
    },
    {
      "name": "Tauqeer",
      "lastMessage": "Bye",
      "date": DateTime.now(),
      "isRead": false,
      "numberOfNewMessages": 3
    },
    {
      "name": "Tauqeer",
      "lastMessage": "Bye",
      "date": DateTime.now(),
      "isRead": false,
      "numberOfNewMessages": 5
    },
    {
      "name": "Tauqeer",
      "lastMessage": "Bye",
      "date": DateTime.now(),
      "isRead": false,
      "numberOfNewMessages": 6
    },
    {
      "name": "Tauqeer",
      "lastMessage": "Bye",
      "date": DateTime.now(),
      "isRead": true,
      "numberOfNewMessages": 0
    },
    {
      "name": "Tauqeer",
      "lastMessage": "Bye",
      "date": DateTime.now(),
      "isRead": false,
      "numberOfNewMessages": 3
    },
    {
      "name": "Tauqeer",
      "lastMessage": "Bye",
      "date": DateTime.now(),
      "isRead": false,
      "numberOfNewMessages": 8
    },
    {
      "name": "Tauqeer",
      "lastMessage": "Bye",
      "date": DateTime.now(),
      "isRead": true,
      "numberOfNewMessages": 0
    },
  ];

  List<Map<String, dynamic>> get recentChats {
    return [..._recentChats];
  }
}
