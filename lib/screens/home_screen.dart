import 'package:chat_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    {
      "buttonName": 'Profile',
      "buttonIcon": Icons.supervised_user_circle_rounded
    },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ping Me",
          style: GoogleFonts.rubik(),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
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
      body: const Center(child: Text("HomeScreen")),
    );
  }
}
