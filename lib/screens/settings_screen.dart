import 'package:flutter/material.dart';
import 'package:google_keep_notes_clone/screens/login_screen.dart';
import 'package:google_keep_notes_clone/services/auth.dart';
import 'package:google_keep_notes_clone/services/login_info.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // bool isSyncEnabled = false; // State for Sync toggle
  bool isHelpFeedbackEnabled = false; // State for Help & Feedback toggle

  late bool value;
  getSyncSettings() async {
    await LocalDataSaver.getSyncSettings().then((valueFromDB) {
      setState(() {
        value = valueFromDB!;
      });
    });
  }

  @override
  initState() {
    getSyncSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Set icon and color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text(
              "Sync",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            value: value,
            onChanged: (bool newValue) {
              setState(() {
                value = newValue;
                LocalDataSaver.saveSyncSettings(newValue);
              });
            },
            activeColor: Colors.blue,
          ),
          SwitchListTile(
            title: const Text(
              "Help & Feedback",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            value: isHelpFeedbackEnabled,
            onChanged: (bool value) {
              setState(() {
                isHelpFeedbackEnabled = value;
              });
            },
            activeColor: Colors.blue,
          ),
          const ListTile(
            title: Text(
              "Account",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
          ),

          const SizedBox(height: 60),
          // const Spacer(), // Pushes the logout button to the bottom
          Center(
            child: SizedBox(
              width: 190,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.grey.shade500, // Button background color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  FirebaseAuthServices().signOut();
                  LocalDataSaver.saveLoginData(false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen())); // Example action
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
