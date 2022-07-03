import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  static const route = "/profile-screen";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var _storedImage;
  var imageChanged = false;

  var _isEditing = false;

  String url = "";

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            width: 15,
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              "Saving...",
              style: GoogleFonts.rubik(),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> pickImage() async {
    imageChanged = true;
    final image = ImagePicker();
    final imageFile =
        await image.pickImage(source: ImageSource.camera, maxWidth: 300);

    setState(() {
      _storedImage = File(imageFile!.path);
    });
  }

  Future<void> saveUserDetails(BuildContext ctx) async {
    showLoaderDialog(ctx);

    final auth = FirebaseAuth.instance;

    final userContact = auth.currentUser!.displayName!.substring(0, 10);

    if (imageChanged) {
      final ref = FirebaseStorage.instance
          .ref()
          .child("user_image")
          .child(userContact + ".jpg");

      await ref.putFile(_storedImage);

      url = await ref.getDownloadURL();
    }

    var phoneAndName =
        _changePhoneController.text + _changeUserNameController.text;

    await auth.currentUser?.updateDisplayName(phoneAndName);
    await auth.currentUser?.updateEmail(_changeEmailController.text);

    if (imageChanged) {
      await auth.currentUser?.updatePhotoURL(url);
      imageChanged = false;
    }

    Navigator.pop(ctx);

    setState(() {});
  }

  final _form = GlobalKey<FormState>();

  final Key _changeUserNameKey = GlobalKey<FormState>();
  final _changeUserNameNode = FocusNode();
  final _changeUserNameController = TextEditingController();

  final Key _changePhoneKey = GlobalKey<FormState>();
  final _changePhoneNode = FocusNode();
  final _changePhoneController = TextEditingController();

  final Key _changeEmailKey = GlobalKey<FormState>();
  final _changeEmailNode = FocusNode();
  final _changeEmailController = TextEditingController();

  final Key _changePasswordKey = GlobalKey<FormState>();
  final _changePasswordNode = FocusNode();
  final _changePasswordController = TextEditingController();

  final Key _changeCnfPasswordKey = GlobalKey<FormState>();
  final _changeCnfPasswordNode = FocusNode();
  final _changeCnfPasswordController = TextEditingController();

  var passwordForCnf = "";

  var _isvalid = true;

  bool isEmailValid(String? email) {
    return email!.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"));
  }

  void _saveForm(BuildContext ctx) {
    _isvalid = _form.currentState?.validate() as bool;
    if (_isvalid == false) {
      return;
    }

    setState(() {
      _isEditing = !_isEditing;
    });

    saveUserDetails(ctx);

    _changePasswordController.clear();
    _changeCnfPasswordController.clear();
  }

  @override
  void initState() {
    super.initState();

    final auth = FirebaseAuth.instance;
    _changeUserNameController.text =
        auth.currentUser?.displayName?.substring(10) as String;
    _changePhoneController.text = auth.currentUser?.displayName == null
        ? ""
        : auth.currentUser?.displayName?.substring(0, 10) as String;

    _changeEmailController.text = auth.currentUser?.email as String;


    if(auth.currentUser?.photoURL != null){
        url = auth.currentUser?.photoURL as String;
    }
}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? "Update Profile" : "Profile",
          style: GoogleFonts.rubik(),
        ),
        actions: [
          if (!_isEditing)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 15,
              ),
              label: Text(
                "Edit",
                style: GoogleFonts.rubik(color: Colors.white),
              ),
            ),
          if (_isEditing)
            TextButton.icon(
              onPressed: () {
                _saveForm(context);
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
                size: 15,
              ),
              label: Text(
                "Save",
                style: GoogleFonts.rubik(color: Colors.white),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              url == ""
                  ? const Icon(
                      Icons.account_circle_rounded,
                      size: 220,
                      color: Colors.grey,
                    )
                  : Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 3, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          child: Image.network(
                            url,
                            errorBuilder: ((context, error, stackTrace) => const Icon(Icons.account_circle_rounded)),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              if (_isEditing)
                TextButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.edit),
                  label: Text(
                    "Change Profile Image",
                    style: GoogleFonts.rubik(),
                  ),
                ),
              SizedBox(
                width: mediaQuery.size.width * 0.9,
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        key: _changeUserNameKey,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: GoogleFonts.rubik(),
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        focusNode: _changeUserNameNode,
                        controller: _changeUserNameController,
                        enabled: _isEditing,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_changePhoneNode);
                        },
                        validator: (userName) {
                          if (userName == "") {
                            return "Please enter a valid username.";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        key: _changePhoneKey,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: GoogleFonts.rubik(),
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        focusNode: _changePhoneNode,
                        controller: _changePhoneController,
                        enabled: _isEditing,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_changeEmailNode);
                        },
                        validator: (number) {
                          if (number!.length < 10) {
                            return "Please enter a valid username.";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        key: _changeEmailKey,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: GoogleFonts.rubik(),
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _changeEmailNode,
                        controller: _changeEmailController,
                        enabled: _isEditing,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_changePasswordNode);
                        },
                        validator: (email) {
                          if (email == "" || !isEmailValid(email)) {
                            return "Invalid Email";
                          } else {
                            return null;
                          }
                        },
                      ),
                      if (_isEditing)
                        TextFormField(
                          key: _changePasswordKey,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: GoogleFonts.rubik(),
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.visiblePassword,
                          focusNode: _changePasswordNode,
                          controller: _changePasswordController,
                          enabled: _isEditing,
                          onChanged: (password) {
                            passwordForCnf = password;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_changeCnfPasswordNode);
                          },
                          validator: (password) {
                            if (password!.length < 8) {
                              return "Password must have 8 characters.";
                            } else {
                              passwordForCnf = password;
                              return null;
                            }
                          },
                        ),
                      if (_isEditing)
                        TextFormField(
                          key: _changeCnfPasswordKey,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: GoogleFonts.rubik(),
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.visiblePassword,
                          focusNode: _changeCnfPasswordNode,
                          controller: _changeCnfPasswordController,
                          enabled: _isEditing,
                          onFieldSubmitted: (_) {},
                          validator: (password) {
                            if (password == passwordForCnf) {
                              return null;
                            } else {
                              return "Password do not match.";
                            }
                          },
                        )
                    ],
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
