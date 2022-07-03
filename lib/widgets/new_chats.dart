import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewChatTile extends StatelessWidget {
  final String name;
  final String number;
  const NewChatTile({required this.name, required this.number, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: ClipOval(
          child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/ping-me-8fbb6.appspot.com/o/user_image%2F$number.jpg?alt=media",
                  errorBuilder: ((context, error, stackTrace) => const Icon(Icons.account_circle_rounded)),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
      ),
      title: Text(
        name,
        style: GoogleFonts.rubik(),
      ),
      subtitle: Text(
        number,
        style: GoogleFonts.rubik(),
      ),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(ChatScreen.route,
            arguments: {"name": name, "phoneNumber": number});
      },
    );
  }
}
