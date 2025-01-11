import 'package:flutter/material.dart';
import 'package:google_keep_notes_clone/model/my_note_model.dart';
import 'package:google_keep_notes_clone/screens/notes_screen.dart';
import 'package:google_keep_notes_clone/services/db.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';

class EditNoteScreen extends StatefulWidget {
  EditNoteScreen({super.key, required this.note});

  Note note;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late String newTitle;

  late String newContent;

  @override
  initState() {
    newContent = widget.note.content.toString();
    newTitle = widget.note.title.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            splashRadius: 16,
            icon: const Icon(Icons.save_outlined, color: Colors.white),
            onPressed: () async {
              // Perform save operation
              Note newNote = Note(
                  content: newContent,
                  title: newTitle,
                  createdTime: widget.note.createdTime,
                  pin: widget.note.pin,
                  id: widget.note.id,
                  isArchived: widget.note.isArchived);
              await NotesDatabase.instance.updateNote(newNote);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteViewScreen(note: newNote)));
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                initialValue: newTitle,
                keyboardType: TextInputType.multiline,
                cursorColor: white,
                onChanged: (value) => newTitle = value,
                style: const TextStyle(fontSize: 25, color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8)),
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Form(
                child: TextFormField(
                  onChanged: (value) => newContent = value,
                  initialValue: newContent,
                  minLines: 50,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  cursorColor: white,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Note',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
