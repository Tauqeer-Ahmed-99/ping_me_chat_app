import 'package:chat_app/helpers/DBhelper.dart';
import 'package:chat_app/models/recent_chats.dart';

import 'package:flutter/cupertino.dart';

class RecentChats with ChangeNotifier {
  RecentChats() {
    fetchAndSetRecentChatsFromStorage();
  }
  List<RecentChat> _recentChats = [];

  List<RecentChat> get recentChats {
    return [..._recentChats];
  }

  Future<void> fetchAndSetRecentChatsFromStorage() async {
    final dbHelper = DBHelper.instance;
    final chats = await dbHelper.queryAllRows();
    
    var recent = chats
        .map((e) => RecentChat(
            name: e["name"],
            id: e["id"],
            number: e["number"],
            isRead: e["isRead"] == "true" ? true : false,
            numberOfNewMessages: e["numberOfNewMessages"],
            dateTime: e["dateTime"],
            lastMessage: e["lastMessage"],))
        .toList();

    _recentChats = recent.reversed.toList();

    notifyListeners();
  }

  void addRecentChat(RecentChat recentChat) {
    _recentChats.removeWhere(
        (RecentChat element) => element.number == recentChat.number);

    _recentChats = [recentChat, ..._recentChats];

    final dbHelper = DBHelper.instance;

    dbHelper.delete(recentChat.number);

    dbHelper.insert({
      "id": recentChat.id,
      "name": recentChat.name,
      "number": recentChat.number,
      "numberOfNewMessages": recentChat.numberOfNewMessages,
      "isRead": recentChat.isRead ? "true" : "false",
      "dateTime": recentChat.dateTime,
      "lastMessage": recentChat.lastMessage
    });

    notifyListeners();
  }
}
