import 'package:flutter/material.dart';
import 'package:google_keep_notes_clone/home.dart';
import 'package:google_keep_notes_clone/model/my_note_model.dart';

import 'package:google_keep_notes_clone/screens/edit_note_screen.dart';
import 'package:google_keep_notes_clone/services/db.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';
import 'package:intl/intl.dart';

class NoteViewScreen extends StatefulWidget {
  NoteViewScreen({super.key, required this.note});

  Note note;

  @override
  State<NoteViewScreen> createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
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
        actions: [
          IconButton(
            splashRadius: 16,
            icon: Icon(
                widget.note.pin ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.white), // Set icon and color
            onPressed: () async {
              await NotesDatabase.instance.pinNote(widget.note);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          IconButton(
            splashRadius: 16,
            icon: const Icon(Icons.delete_outline,
                color: Colors.white), // Set icon and color
            onPressed: () async {
              await NotesDatabase.instance.deleteNote(widget.note);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          IconButton(
            splashRadius: 16,
            icon: Icon(
                widget.note.isArchived ? Icons.archive : Icons.archive_outlined,
                color: Colors.white),
            onPressed: () async {
              await NotesDatabase.instance.archivedNotes(widget.note);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          IconButton(
            splashRadius: 16,
            icon: const Icon(Icons.edit_outlined,
                color: Colors.white), // Set icon and color
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNoteScreen(note: widget.note),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Created on: ${DateFormat('dd-MM-yy - kk:mm').format(widget.note.createdTime)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.note.title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.note.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
