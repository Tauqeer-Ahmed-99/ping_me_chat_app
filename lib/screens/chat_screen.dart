import 'package:chat_app/models/recent_chats.dart';
import 'package:chat_app/providers/recentChats_provider.dart';
// import 'package:chat_app/providers/users_provider.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  static const route = "/chatscreen";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var key = GlobalKey();
  var node = FocusNode();

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    var inputController = TextEditingController();

    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    var recentChats = Provider.of<RecentChats>(context, listen: false);

    var userNumber = arguments["phoneNumber"];
    var userName = arguments["name"];

    // var senderNumber = "";
    var senderNumber = "";
    var senderName = "";

    // var uniqueAddress = "";

    String cleanRecieverNumber(String number) {
      return number
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll("-", "")
          .replaceAll("+91", "")
          .replaceAll(" ", "");
    }

    Future<String> createUniqueAddress(value1) async {
      // print(value1);

      var prefs = await SharedPreferences.getInstance();

      senderName = prefs.getString("senderName") as String;
      senderNumber = prefs.getString("senderNumber") as String;
      String receiverNumber = value1;

      String cleanReceiverNumber = cleanRecieverNumber(receiverNumber);

      // print(cleanReceiverNumber);
      // print(widget.senderNumber);

      var nlist = [int.parse(cleanReceiverNumber), int.parse(senderNumber)];
      nlist.sort((a, b) => a.compareTo(b));

      // print(nlist.join("").toString());

      // uniqueAddress = nlist.join("").toString();
      return nlist.join("").toString();
    }

    Widget messageBox(futureSnapshot) {
      return Container(
        width: mediaquery.size.width * 0.99,
        margin: const EdgeInsets.symmetric(vertical: 4),
        // height: 40,
        child: Row(
          children: [
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  // height: 40,
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    // expands: true,
                    textAlignVertical: TextAlignVertical.center,
                    style: GoogleFonts.rubik(),
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.rubik(fontSize: 16),
                        hintText: "Message",
                        border: InputBorder.none),
                    controller: inputController,
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (inputController.text.trim().isEmpty) {
                    return;
                  }
                  FirebaseFirestore.instance
                      .collection('chats/${futureSnapshot.data}/messages')
                      .add({
                    "message": inputController.text.trim(),
                    "senderNumber": senderNumber,
                    "senderName": senderName,
                    "datetime": DateTime.now().toIso8601String()
                  });

                  recentChats.addRecentChat(
                    RecentChat(
                      name: userName,
                      number: cleanRecieverNumber(userNumber),
                      lastMessage: inputController.text.trim(),
                      dateTime: DateTime.now().toIso8601String(),
                      isRead: true,
                      numberOfNewMessages: 0,
                      id: DateTime.now().toIso8601String(),
                    ),
                  );
                  inputController.clear();
                },
              ),
            )
          ],
        ),
      );
    }

    return FutureBuilder(
        future: createUniqueAddress(userNumber),
        builder: (BuildContext context, AsyncSnapshot<String> futureSnapshot) {
          print("uniqueAddress => ${futureSnapshot.data}");
          print("senderName -> " + senderName);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                userName,
                style: GoogleFonts.rubik(),
              ),
            ),
            body: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats/${futureSnapshot.data}/messages')
                      .orderBy("datetime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    var chats = snapshot.data!.docs;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: chats.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            var data =
                                chats[index].data()! as Map<String, dynamic>;
                            return MessageBubble(
                              message: data["message"],
                              dateTime: data["datetime"],
                              isOnRight: data["senderName"] == senderName
                                  ? true
                                  : false,
                            );
                          }),
                    );
                  },
                ),
                messageBox(futureSnapshot)
              ], //
            ),
          );
        });
  }
}
