// import 'package:chat_app/providers/users_provider.dart';
// import 'package:chat_app/screens/home_screen.dart';
// import 'package:chat_app/screens/otp_screen.dart';
import 'package:chat_app/providers/auth_provider.dart';
// import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

import '../models/user.dart' as _user;

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var firebase = FirebaseAuth.instance;

  var isLoggingIn = true;
  var isLoggedIn = false;
  var isValid = true;
  var _isLoading = false;

  final _form = GlobalKey<FormState>();
  final _userNameKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordkey = GlobalKey<FormState>();
  final _cnfPasswordkey = GlobalKey<FormState>();

  String userName = "";
  String phoneNumber = "";
  String email = "";
  String password = "";

  bool isEmailValid(String? email) {
    return email!.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
  }

  final _userNameNode = FocusNode();
  final _phoneNumberNode = FocusNode();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _cnfPasswordNode = FocusNode();

  var passwordForCnf = "";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // final auth = Provider.of<Auth>(context);

    // final usersData = Provider.of<UsersProvider>(context);

    void _submitForm(auth) async {
      var user = _user.User(
          userName: userName,
          phoneNumber: phoneNumber,
          email: email,
          password: password);

      print(user.userName);
      print(user.phoneNumber);
      print(user.email);
      print(user.password);

      if (isLoggingIn) {
        setState(() {
          _isLoading = true;
        });

        await auth.signIn(context, user.email, user.password);

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });

        await auth.signUp(context, user.email, user.password);

        setState(() {
          _isLoading = false;
        });
      }
    }

    void _saveForm(auth) {
      var _isvalid = _form.currentState?.validate();
      if (_isvalid == null || _isvalid == false) {
        return;
      }
      _form.currentState?.save();

      _submitForm(auth);
    }

    return Consumer<Auth>(
      builder: (context, auth, child) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: isLoggingIn ? 250 : 430,
        width: mediaQuery.size.width * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              if (!isLoggingIn)
                TextFormField(
                  key: _userNameKey,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: GoogleFonts.rubik(),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  focusNode: _userNameNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_phoneNumberNode);
                  },
                  validator: (userName) {
                    if (userName == "") {
                      return "Please enter a valid username.";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (_userName) {
                    userName = _userName;
                  },
                  onSaved: (_userName) {
                    userName = _userName as String;
                  },
                ),
              if (!isLoggingIn)
                TextFormField(
                  key: _phoneKey,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: GoogleFonts.rubik(),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  focusNode: _phoneNumberNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailNode);
                  },
                  validator: (phoneNumber) {
                    if (phoneNumber == "" || phoneNumber!.length < 10) {
                      return "Please enter a valid Phone number.";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (_phoneNumber) {
                    phoneNumber = _phoneNumber;
                  },
                  onSaved: (_phoneNumber) {
                    phoneNumber = _phoneNumber as String;
                  },
                ),
              TextFormField(
                key: _emailKey,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: GoogleFonts.rubik(),
                ),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                focusNode: _emailNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordNode);
                },
                validator: (email) {
                  if (email == "" || !isEmailValid(email)) {
                    return "Invalid Email";
                  } else {
                    return null;
                  }
                },
                onChanged: (_email) {
                  email = _email;
                },
                onSaved: (_email) {
                  email = _email as String;
                },
              ),
              TextFormField(
                key: _passwordkey,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: GoogleFonts.rubik(),
                ),
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                focusNode: _passwordNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_cnfPasswordNode);
                },
                validator: (password) {
                  if (password!.length < 8) {
                    return "Password must have 8 characters.";
                  } else {
                    passwordForCnf = password;
                    return null;
                  }
                },
                onChanged: (_password) {
                  password = _password;
                },
                onSaved: (_password) {
                  password = _password as String;
                },
              ),
              if (!isLoggingIn)
                TextFormField(
                  key: _cnfPasswordkey,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: GoogleFonts.rubik(),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _cnfPasswordNode,
                  onFieldSubmitted: (_) {
                    _saveForm(auth);
                  },
                  validator: (cnfPassword) {
                    if (cnfPassword != passwordForCnf) {
                      return "Passwords do not match.";
                    } else if (cnfPassword == "") {
                      return "Please Re-enter your password.";
                    } else {
                      return null;
                    }
                  },
                ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          isLoggingIn ? "Login" : "Signup",
                          style: GoogleFonts.rubik(fontSize: 24),
                        ),
                ),
                onPressed: () => _saveForm(auth),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Text(
                    isLoggingIn
                        ? "Don't have an account? Signup instead."
                        : "Already have an account? Login instead.",
                    style: GoogleFonts.rubik(fontSize: 15),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isLoggingIn = !isLoggingIn;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
