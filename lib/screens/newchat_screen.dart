import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewChatScreen extends StatefulWidget {
  static const route = "/newchatscreen";
  const NewChatScreen({Key? key}) : super(key: key);

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  var _isLoading = false;

  List<Contact> contacts = [];

  @override
  void initState() {
    initial();

    super.initState();
  }

  void initial() async {
    setState(() {
      _isLoading = true;
    });
    contacts = await ContactsService.getContacts();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    children: [
                      Text(
                        "Fetching contacts, please wait...",
                        style: GoogleFonts.rubik(),
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                )
              : Center(
                  child: Row(
                    children: [
                      Text(
                        "Fetching contacts, please wait...",
                        style: GoogleFonts.rubik(),
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                )
          : !_isLoading && contacts.isEmpty
              ? Center(
                  child: Text(
                    "Contacts not found.",
                    style: GoogleFonts.rubik(),
                  ),
                )
              : ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: ((context, index) => ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.account_circle_rounded),
                        ),
                        title: Text(
                          contacts[index].displayName as String,
                          style: GoogleFonts.rubik(),
                        ),
                        subtitle: Text(
                          contacts[index].phones?[0].value as String,
                          style: GoogleFonts.rubik(),
                        ),
                        onTap: () {},
                      )),
                ),
    );
  }
}
