import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RecentChatTile extends StatelessWidget {
  final String name;
  final String lastMesssage;
  final String date;
  final bool isRead;
  final int numberOfUnreadMessages;
  final VoidCallback onTap;
  const RecentChatTile({
    Key? key,
    required this.name,
    required this.date,
    required this.lastMesssage,
    required this.isRead,
    required this.numberOfUnreadMessages,
    required this.onTap,
  }) : super(key: key);

  String setVisibleLastMessage(String message) {
    const acceptableLength = 35;
    return message.length < acceptableLength
        ? message
        : "${message.substring(0, acceptableLength)}...";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(backgroundColor: Colors.cyan),
        title: Text(name, style: GoogleFonts.rubik()),
        subtitle: Text(setVisibleLastMessage(lastMesssage),
            style: GoogleFonts.rubik()),
        trailing: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              Text(
                DateFormat.jm().format(DateTime.parse(date)),
                style: GoogleFonts.rubik(
                    color:
                        isRead ? Colors.grey : Theme.of(context).accentColor),
              ),
              if (!isRead) const SizedBox(height: 4),
              if (!isRead)
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          numberOfUnreadMessages.toString(),
                          style: GoogleFonts.rubik(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
