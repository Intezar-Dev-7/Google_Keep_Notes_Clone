import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_keep_notes_clone/home.dart';
import 'package:google_keep_notes_clone/services/firestore_db.dart';
import 'package:google_keep_notes_clone/services/login_info.dart';
import 'package:google_keep_notes_clone/services/auth.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

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
          title: const Text(
            "Welcome to Notes App",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: cardColor,
        ),
        backgroundColor: cardColor,
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  // App Logo
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/icon/appIconNotes.png'),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Your Notes, Anywhere!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sign in to sync and manage your notes seamlessly.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Google Sign-In Button
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    width: 157,
                    height: 35,
                    child: TextButton(
                      child: const Icon(Iconsax.google_1),
                      onPressed: () async {
                        try {
                          await FirebaseAuthServicesI().signInWithGoogle();
                          final User? currentUser = _auth.currentUser;

                          if (currentUser != null) {
                            LocalDataSaver.saveLoginData(true);
                            LocalDataSaver.saveImg(
                                currentUser.photoURL.toString());
                            LocalDataSaver.saveMail(
                                currentUser.email.toString());
                            LocalDataSaver.saveName(
                                currentUser.displayName.toString());
                            LocalDataSaver.saveSyncSettings(false);

                            await FireDB().getAllStoredNotes();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("An error occurred: $e")),
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Footer Text
                  const Text(
                    "We never share your data with anyone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ]))));
  }
}
