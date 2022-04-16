// import 'package:chat_app/models/recent_chats.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/recentChats_provider.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/newchat_screen.dart';
import 'package:chat_app/widgets/recentchat_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/home-screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = false;

  List<Map<String, dynamic>> myMenuItems = [
    {"buttonName": 'Home', "buttonIcon": Icons.home},
    {"buttonName": 'Profile', "buttonIcon": Icons.account_circle_sharp},
    {"buttonName": 'Setting', "buttonIcon": Icons.settings},
    {"buttonName": 'Logout', "buttonIcon": Icons.logout}
  ];

  void onSelect(item, BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    switch (item) {
      case 'Home':
        print('Home clicked');
        break;
      case 'Profile':
        print('Profile clicked');
        break;
      case 'Setting':
        print('Setting clicked');
        break;
      case 'Logout':
        setState(() {
          _isLoading = true;
        });
        await auth.signOut(context);
        setState(() {
          _isLoading = false;
        });
        print('Logout clicked');
        break;
    }
  }

  // void initial() {
  //   Provider.of<RecentChats>(context, listen: false)
  //       .fetchAndSetRecentChatsFromStorage();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   initial();
  // }

  void showNewChatScreen() async {
    PermissionStatus status = await Permission.contacts.status;

    if (status.isDenied) {
      await Permission.contacts.request();
    } else {
      Navigator.of(context).pushNamed(NewChatScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    var recentChats = Provider.of<RecentChats>(context, listen: true);

    // final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ping Me",
          style: GoogleFonts.rubik(),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (String type) => onSelect(type, context),
              itemBuilder: (BuildContext context) {
                return myMenuItems.map((item) {
                  return PopupMenuItem<String>(
                    child: Row(
                      children: [
                        if (_isLoading) const CircularProgressIndicator(),
                        if (!_isLoading)
                          Icon(
                            item["buttonIcon"],
                            color: Colors.cyan[600],
                            size: 24.0,
                          ),
                        if (!_isLoading)
                          const SizedBox(
                            width: 20,
                          ),
                        if (!_isLoading) Text(item["buttonName"])
                      ],
                    ),
                    value: item["buttonName"],
                  );
                }).toList();
              })
        ],
      ),
      body: recentChats.recentChats.isNotEmpty
          ? ListView.builder(
              itemCount: recentChats.recentChats.length,
              itemBuilder: (context, i) {
                print(" homescreen -> ${recentChats.recentChats.length}");
                return RecentChatTile(
                  name: recentChats.recentChats[i].name,
                  date: recentChats.recentChats[i].dateTime,
                  lastMesssage: recentChats.recentChats[i].lastMessage,
                  isRead: recentChats.recentChats[i].isRead,
                  numberOfUnreadMessages:
                      recentChats.recentChats[i].numberOfNewMessages,
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(ChatScreen.route, arguments: {
                      "name": recentChats.recentChats[i].name,
                      "phoneNumber": recentChats.recentChats[i].number
                    });
                  },
                );
              })
          : Center(
              child: Text(
                "No recent chats available.\nStart messaging by clicking button below.",
                style: GoogleFonts.rubik(fontSize: 20, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add_comment_rounded,
            color: Colors.white,
          ),
          onPressed: showNewChatScreen),
    );
  }
}
