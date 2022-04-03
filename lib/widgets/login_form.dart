import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var isLoggingIn = true;
  var isValid = true;

  final _form = GlobalKey<FormState>();

  String? userName = "";
  String? phoneNumber = "";
  String? email = "";
  String? password = "";

  void _saveForm() {
    var _isvalid = _form.currentState?.validate();
    if (_isvalid == null || _isvalid == false) {
      return;
    }
    _form.currentState?.save();
  }

  bool isEmailValid(String? email) {
    return email!.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
  }

  void _submitForm() {
    _saveForm();
    print(userName);
    print(phoneNumber);
    print(email);
    print(password);
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

    return Container(
      padding: const EdgeInsets.all(15),
      width: mediaQuery.size.width - 30,
      height: isLoggingIn
          ? mediaQuery.size.height * 0.5
          : mediaQuery.size.height * 0.7,
      child: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            TextFormField(
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
                userName = _userName;
              },
            ),
            TextFormField(
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
                if (phoneNumber == "") {
                  return "Please enter a valid username.";
                } else {
                  return null;
                }
              },
              onChanged: (_phoneNumber) {
                phoneNumber = _phoneNumber;
              },
              onSaved: (_phoneNumber) {
                phoneNumber = _phoneNumber;
              },
            ),
            TextFormField(
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
                email = _email;
              },
            ),
            TextFormField(
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
                password = _password;
              },
            ),
            if (!isLoggingIn)
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: GoogleFonts.rubik(),
                ),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                focusNode: _cnfPasswordNode,
                onFieldSubmitted: (_) {
                  _saveForm();
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
                child: Text(
                  isLoggingIn ? "Login" : "Signup",
                  style: GoogleFonts.rubik(fontSize: 24),
                ),
              ),
              onPressed: _submitForm,
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
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
    );
  }
}
