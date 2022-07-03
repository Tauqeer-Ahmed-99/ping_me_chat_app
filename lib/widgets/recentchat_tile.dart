import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RecentChatTile extends StatelessWidget {
  final String name;
  final String lastMesssage;
  final String date;
  final String phone;
  final bool isRead;
  final int numberOfUnreadMessages;
  final VoidCallback onTap;
  const RecentChatTile({
    Key? key,
    required this.name,
    required this.date,
    required this.lastMesssage,
    required this.phone,
    required this.isRead,
    required this.numberOfUnreadMessages,
    required this.onTap,
  }) : super(key: key);


  String setVisibleLastMessage(String message) {
    const acceptableLength = 35;
    var messageWithoutLineBreaks = message.replaceAll("\n", " ");
    return messageWithoutLineBreaks.length < acceptableLength
        ? messageWithoutLineBreaks
        : "${messageWithoutLineBreaks.substring(0, acceptableLength)}...";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: ClipOval(
            child:Image.network("https://firebasestorage.googleapis.com/v0/b/ping-me-8fbb6.appspot.com/o/user_image%2F$phone.jpg?alt=media"
                    ,
                    errorBuilder: ((context, error, stackTrace) => const Icon(Icons.account_circle_rounded)),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
        ),
        title: Text(name, style: GoogleFonts.rubik()),
        subtitle: Text(setVisibleLastMessage(lastMesssage),
            style: GoogleFonts.rubik()),
        trailing: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.parse(date)) ==
                        DateFormat.yMMMd().format(DateTime.now())
                    ? DateFormat.jm().format(DateTime.parse(date))
                    : DateFormat.yMMMd().format(DateTime.parse(date)),
                style: GoogleFonts.rubik(
                    color: isRead
                        ? Colors.grey
                        : Theme.of(context).colorScheme.secondary),
              ),
              if (!isRead) const SizedBox(height: 4),
              if (!isRead)
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
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
