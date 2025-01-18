import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_keep_notes_clone/home.dart';
import 'package:google_keep_notes_clone/screens/login_screen.dart';
import 'package:google_keep_notes_clone/services/login_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogIn = false;

  getLoggedInState() async {
    await LocalDataSaver.getLogData().then((value) {
      setState(() {
        isLogIn = value!;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Kepp Notes Clone',
      home: isLogIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
