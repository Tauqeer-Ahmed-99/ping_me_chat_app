import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatefulWidget {
  static const route = "/otp-screen";

  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final nodeOne = FocusNode();
  final nodeTwo = FocusNode();
  final nodeThree = FocusNode();
  final nodeFour = FocusNode();
  final nodeFive = FocusNode();
  final nodeSix = FocusNode();

  var isInit = true;

  var one = "";
  var two = "";
  var three = "";
  var four = "";
  var five = "";
  var six = "";

  var otp = "";

  void makeOtp() {
    setState(() {
      otp = one + two + three + four + five + six;
    });
  }

  void _submitOtp(getOtp) {
    // print(otp);

    getOtp(otp);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final getOtp = ModalRoute.of(context)!.settings.arguments;

    // final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter OTP"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "We have sent you an OTP please enter:",
              style: GoogleFonts.rubik(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.cyan[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan[700] as Color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.rubik(),
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: nodeOne,
                    onChanged: (value) {
                      one = value;
                      makeOtp();
                      FocusScope.of(context).requestFocus(nodeTwo);
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan[700] as Color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.rubik(),
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: nodeTwo,
                    onChanged: (value) {
                      two = value;
                      makeOtp();
                      FocusScope.of(context).requestFocus(nodeThree);
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan[700] as Color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.rubik(),
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: nodeThree,
                    onChanged: (value) {
                      three = value;
                      makeOtp();
                      FocusScope.of(context).requestFocus(nodeFour);
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan[700] as Color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.rubik(),
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: nodeFour,
                    onChanged: (value) {
                      four = value;
                      makeOtp();
                      FocusScope.of(context).requestFocus(nodeFive);
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan[700] as Color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.rubik(),
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: nodeFive,
                    onChanged: (value) {
                      five = value;
                      makeOtp();
                      FocusScope.of(context).requestFocus(nodeSix);
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan[700] as Color),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.rubik(),
                    ),
                    keyboardType: TextInputType.number,
                    focusNode: nodeSix,
                    onChanged: (value) {
                      six = value;
                      makeOtp();
                      if (value.length == 1) {
                        FocusScope.of(context).unfocus();
                        return;
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            if (otp.length != 6 && isInit)
              Text(
                "Please Enter a valid otp.",
                style: GoogleFonts.rubik(
                    fontSize: 16, color: Theme.of(context).errorColor),
              ),
            if (otp.length != 6 && isInit) const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't recieved code",
                  style: GoogleFonts.rubik(),
                ),
                const SizedBox(
                  width: 30,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Resend",
                    style: GoogleFonts.rubik(),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              height: 70,
              width: 200,
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                child: Text(
                  "Verify",
                  style: GoogleFonts.rubik(
                      fontSize: 24, fontWeight: FontWeight.w400),
                ),
                onPressed: otp.length == 6
                    ? () {
                        _submitOtp(getOtp);
                      }
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
