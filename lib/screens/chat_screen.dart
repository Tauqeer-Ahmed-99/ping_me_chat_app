import 'package:chat_app/models/recent_chats.dart';
import 'package:chat_app/providers/recentChats_provider.dart';
import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

    var firebase = FirebaseAuth.instance;
    var senderNumber = firebase.currentUser!.displayName!.substring(0, 10);

    Future<String> createUniqueAddress(value1) async {
      String receiverNumber = value1;


      var nlist = [int.parse(receiverNumber), int.parse(senderNumber)];
      nlist.sort((a, b) => a.compareTo(b));

      return nlist.join("").toString();
    }

    Widget messageBox(futureSnapshot) {
      return Container(
        width: mediaquery.size.width * 0.99,
        margin: const EdgeInsets.symmetric(vertical: 4),
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
                    "datetime": DateTime.now().toIso8601String()
                  });

                  recentChats.addRecentChat(
                    RecentChat(
                      name: userName,
                      number: userNumber,
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
                              isOnRight: data["senderNumber"] == senderNumber
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
