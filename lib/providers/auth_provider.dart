import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  final firebase = FirebaseAuth.instance;

  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      var res = await firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = res.user;
      // Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } catch (error) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Something went wrong! Try again.",
            style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  Future<void> signUp(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      var res = await firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(res);
      // Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong! Try again.",
              style:
                  GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.bold)),
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }
}
