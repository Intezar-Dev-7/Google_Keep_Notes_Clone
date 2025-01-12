import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_keep_notes_clone/home.dart';
import 'package:google_keep_notes_clone/services/firestore_db.dart';
import 'package:google_keep_notes_clone/services/login_info.dart';
import 'package:google_keep_notes_clone/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SignInButton(Buttons.Google, onPressed: () async {
            try {
              await signInWithGoogle();
              final User? currentUser = _auth.currentUser;

              if (currentUser != null) {
                LocalDataSaver.saveLoginData(true);
                LocalDataSaver.saveImg(currentUser.photoURL ?? "");
                LocalDataSaver.saveMail(currentUser.email ?? "");
                LocalDataSaver.saveName(currentUser.displayName ?? "");

                await FireDB().getAllStoredNotes();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            } catch (e) {
              // Log or show the error to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("An error occurred: $e")),
              );
            }
          })
        ])));
  }
}
