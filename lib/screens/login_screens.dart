import 'package:flutter/material.dart';

import 'package:chat_app/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ping Me",
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: 250,
                child: Image.asset("assets/Ping-ME.png"),
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
