import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String dateTime;
  final bool isOnRight;
  const MessageBubble(
      {Key? key,
      required this.message,
      required this.dateTime,
      required this.isOnRight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Row(
      mainAxisAlignment:
          isOnRight ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isOnRight
                ? Colors.grey[200]
                : Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
                topLeft: isOnRight
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
                topRight: isOnRight
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
                bottomRight: const Radius.circular(12),
                bottomLeft: const Radius.circular(12)),
          ),
          constraints: BoxConstraints(
              maxWidth: mediaQuery.size.width * 0.75, minWidth: 0),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: GoogleFonts.rubik(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: mediaQuery.size.width * 0.75, minWidth: 0),
                child: Text(
                  "${DateFormat.jm().format(DateTime.parse(dateTime))} ${DateFormat.yMMMd().format(DateTime.parse(dateTime)) == DateFormat.yMMMd().format(DateTime.now()) ? " • today" : DateFormat.y().format(DateTime.parse(dateTime)) == DateFormat.y().format(DateTime.now()) ? " • ${DateFormat.MMMd().format(DateTime.parse(dateTime))}" : " • ${DateFormat.yMMMd().format(DateTime.parse(dateTime))}"}",
                  style: GoogleFonts.rubik(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
