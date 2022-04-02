import 'package:flutter/material.dart';

import 'package:chat_app/widgets/login_form.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ping Me",
          style: GoogleFonts.rubik(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: 250,
                child: Image.asset("assets/gif/Ping-ME.gif"),
              ),
              const SizedBox(
                height: 30,
              ),
              const Card(
                elevation: 10,
                child: LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
