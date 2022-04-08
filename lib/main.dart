import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/recentChats_provider.dart';
// import 'package:chat_app/providers/users_provider.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screens.dart';
import 'package:chat_app/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
  // See related issue: https://github.com/flutter/flutter/issues/96391

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: FirebaseOpts.apiKey,
      appId: FirebaseOpts.appId,
      messagingSenderId: FirebaseOpts.messagingSenderID,
      projectId: FirebaseOpts.projectId,
    ),
  );

  Provider.debugCheckInvalidValueType = null;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Map<int, Color> _yellow700Map = {
      50: const Color.fromRGBO(3, 152, 158, 1),
      100: Colors.cyan[100] as Color,
      200: Colors.cyan[200] as Color,
      300: Colors.cyan[300] as Color,
      400: Colors.cyan[400] as Color,
      500: Colors.cyan[500] as Color,
      600: Colors.cyan[600] as Color,
      700: Colors.cyan[800] as Color,
      800: Colors.cyan[900] as Color,
      900: Colors.cyan[700] as Color,
    };

    return MultiProvider(
      providers: [
        Provider<Auth>(create: (context) => Auth()),
        Provider<RecentChats>(create: (context) => RecentChats())
      ],
      child: MaterialApp(
        title: 'Ping ME',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: MaterialColor(Colors.cyan[800]!.value, _yellow700Map),
          backgroundColor: const Color.fromARGB(255, 125, 239, 243),
          accentColor: Colors.cyan[500],
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.indigoAccent,
              textTheme: ButtonTextTheme.accent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
        ),
        routes: {
          OtpScreen.route: (context) => const OtpScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapShot) {
            if (userSnapShot.hasData) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
