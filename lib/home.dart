import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_notes_clone/model/my_note_model.dart';
import 'package:google_keep_notes_clone/screens/new_note_screen.dart';
import 'package:google_keep_notes_clone/screens/notes_screen.dart';

import 'package:google_keep_notes_clone/services/db.dart';
import 'package:google_keep_notes_clone/services/firestore_db.dart';
import 'package:google_keep_notes_clone/side_menu_bar.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  bool isLoading = true;
  late List<Note> notesList = [];

  @override
  void initState() {
    super.initState();

    FireDB().createNewNoteFirestore(Note(
      pin: false,
      title: "Flutter Notes",
      content:
          "This is a note taking app, built with flutter. It allows you to create, edit, and delete notes. You can also search for notes and organize them in a grid or list view.",
      createdTime: DateTime.now(),
      isArchived: false,
    ));
    getAllNotes();
    // resetDatabase();
  }

  Future createEntry(Note note) async {
    await NotesDatabase.instance.insertEntry(note);
  }

//
  Future getAllNotes() async {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future getOneNote(int id) async {
    await NotesDatabase.instance.readOneNote(id);
  }

  Future updateOneNote(Note note) async {
    await NotesDatabase.instance.updateNote(note);
  }

  Future deleteNote(Note note) async {
    await NotesDatabase.instance.deleteNote(note);
  }

  Future resetDatabase() async => await NotesDatabase.instance.resetDatabase();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            endDrawerEnableOpenDragGesture: true,
            drawer: const SideMenuBar(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewNoteScreen()));
              },
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.add,
                size: 45,
              ),
            ),
            backgroundColor: bgColor,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  const SearchBar(),
                  if (notesList.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 300),
                      child: Center(
                        child: Text(
                          "No Notes Yet",
                          style: TextStyle(
                              color: white.withOpacity(0.5), fontSize: 20),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "All Notes",
                                style: TextStyle(
                                    color: white.withOpacity(0.5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_sweep,
                                  color: white,
                                ),
                                onPressed: () async {
                                  bool confirm = await showDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Delete All Notes"),
                                      content: const Text(
                                          "Are you sure you want to delete all notes?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text("No")),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm) {
                                    await NotesDatabase.instance
                                        .deleteAllNotes();
                                    setState(() {
                                      notesList.clear();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          child: MasonryGridView.builder(
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: notesList.length,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NoteViewScreen(
                                              note: notesList[index],
                                            )));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: white.withOpacity(0.4)),
                                    borderRadius: BorderRadius.circular(7)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(notesList[index].title,
                                        style: const TextStyle(
                                            color: white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text(
                                      notesList[index].content.length > 250
                                          ? "${notesList[index].content.substring(0, 250)}..."
                                          : notesList[index].content,
                                      style: const TextStyle(color: white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            )),
          );
  }
}
