
import 'package:chat_app/widgets/new_chats.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class NewChatScreen extends StatefulWidget {
  static const route = "/newchatscreen";
  const NewChatScreen({Key? key}) : super(key: key);

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  var _isLoading = false;

  List<Contact> contacts = [];

  var contactsStatus = false;

  @override
  void initState() {
    initial();

    super.initState();
  }

  void initial() async {
    setState(() {
      _isLoading = true;
    });

    PermissionStatus status = await Permission.contacts.status;

    if (status.isGranted) {
      contactsStatus = true;
      contacts = await FlutterContacts.getContacts(withProperties: true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  String cleanPhoneNumber(String number) {
    return number
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("-", "")
        .replaceAll("+91", "")
        .replaceAll(" ", "");
  }
  
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Select Contact",
        style: GoogleFonts.rubik(),
      )),
      body: _isLoading
          ? _isLoading
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      Text(
                        "Loading, please wait...",
                        style: GoogleFonts.rubik(
                            fontSize: 18, color: Colors.cyan[700]),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Fetching contacts, please wait...",
                        style: GoogleFonts.rubik(
                            fontSize: 18, color: Colors.cyan[700]),
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                )
          : !_isLoading && contacts.isEmpty
              ? Center(
                  child: Text(
                    "Contacts not found.",
                    style: GoogleFonts.rubik(
                        fontSize: 18, color: Colors.cyan[700]),
                  ),
                )
              : !_isLoading && contactsStatus
                  ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      height: mediaQuery.size.height -
                          mediaQuery.padding.bottom -
                          mediaQuery.padding.top,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: ((context, index) {
                          return NewChatTile(
                              name: contacts[index].displayName,
                              number:
                                  cleanPhoneNumber(contacts[index].phones[0].number.toString()));
                        }),
                      ),
                    )
                  : Center(
                      child: Text(
                        "Contacts permissions not granted.",
                        style: GoogleFonts.rubik(),
                      ),
                    ),
    );
  }
}
