import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                ? Colors.grey[300]
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
          width: mediaQuery.size.width * 0.6,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: GoogleFonts.rubik(),
          ),
        ),
      ],
    );
  }
}
