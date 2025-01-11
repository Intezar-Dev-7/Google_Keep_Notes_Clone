import 'package:flutter/material.dart';
import 'package:google_keep_notes_clone/screens/settings_screen.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';
import 'package:google_keep_notes_clone/screens/archive_screen.dart';

class SideMenuBar extends StatefulWidget {
  const SideMenuBar({super.key});

  @override
  State<SideMenuBar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SideMenuBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: bgColor),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
                child: const Text('Google Keep',
                    style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
              Divider(color: white.withOpacity(0.3)),
              sideBarNotesSection(),
              const SizedBox(height: 5),
              sideBarArchiveSection(),
              const SizedBox(height: 5),
              sideBarSettingsSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget sideBarNotesSection() {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Colors.orangeAccent.withOpacity(0.3)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ))),
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: 27,
                    color: white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 17),
                  Text('Notes',
                      style: TextStyle(
                          color: white.withOpacity(0.7), fontSize: 18))
                ],
              ),
            )));
  }

  Widget sideBarArchiveSection() {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
            ))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ArchiveScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(
                    Icons.archive_outlined,
                    size: 27,
                    color: white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 17),
                  Text('Archive',
                      style: TextStyle(
                          color: white.withOpacity(0.7), fontSize: 18))
                ],
              ),
            )));
  }

  Widget sideBarSettingsSection() {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
            ))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 27,
                    color: white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 17),
                  Text('Settings',
                      style: TextStyle(
                          color: white.withOpacity(0.7), fontSize: 18))
                ],
              ),
            )));
  }
}
