import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_notes_clone/model/my_note_model.dart';
import 'package:google_keep_notes_clone/screens/login_screen.dart';
import 'package:google_keep_notes_clone/screens/new_note_screen.dart';
import 'package:google_keep_notes_clone/screens/notes_screen.dart';
import 'package:google_keep_notes_clone/screens/search_screen.dart';
import 'package:google_keep_notes_clone/services/db.dart';
import 'package:google_keep_notes_clone/services/login_info.dart';
import 'package:google_keep_notes_clone/side_menu_bar.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';
import 'package:google_keep_notes_clone/services/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  bool isLoading = true;
  late String? imgUrl;

  List<Note> notesList = [];
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    getAllNotes();
  }

  Future createEntry(Note note) async {
    await NotesDatabase.instance.insertEntry(note);
  }

  Future getAllNotes() async {
    LocalDataSaver.getImg().then((value) {
      if (mounted) {
        setState(() {
          imgUrl = value;
        });
      }
    });

    notesList = await NotesDatabase.instance.readAllNotes();
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

  Future deleteAllNotes() async {
    bool confirm = await showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete All Notes"),
        content: const Text("Are you sure you want to delete all notes?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm) {
      await NotesDatabase.instance.deleteAllNotes();
      setState(() {
        notesList.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewNoteScreen()),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, size: 45),
            ),
            key: _drawerKey,
            drawer: const SideMenuBar(),
            backgroundColor: bgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(),
                    if (notesList.isEmpty) _buildNoNotesMessage(),
                    if (notesList.isNotEmpty) _buildNotesGrid(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildAppBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 55,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: black.withOpacity(0.2), spreadRadius: 1, blurRadius: 3),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _drawerKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu, color: white),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()),
                  );
                },
                child: SizedBox(
                  height: 55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Search Your Notes",
                          style: TextStyle(
                              color: white.withOpacity(0.5), fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Icon(Icons.grid_view, color: white),
                ),
                const SizedBox(width: 9),
                GestureDetector(
                  onTap: () {
                    FirebaseAuthServices().signOut();
                    LocalDataSaver.saveLoginData(false);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: CircleAvatar(
                    onBackgroundImageError: (Object, StackTrace) {
                      print("Ok");
                    },
                    radius: 16,
                    backgroundImage: NetworkImage(imgUrl.toString()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoNotesMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 300),
      child: Center(
        child: Text(
          "No Notes Yet",
          style: TextStyle(color: white.withOpacity(0.5), fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildNotesGrid() {
    return Column(
      children: [
        // This is where the "All Notes" header and "Delete All Notes" icon are aligned
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                icon: const Icon(Icons.delete_sweep, color: white),
                onPressed: deleteAllNotes,
              ),
            ],
          ),
        ),
        // Grid for notes
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: MasonryGridView.builder(
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
                    builder: (context) =>
                        NoteViewScreen(note: notesList[index]),
                  ),
                );
              },
              child: _buildNoteCard(notesList[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: white.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: const TextStyle(
                color: white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            note.content.length > 250
                ? "${note.content.substring(0, 250)}..."
                : note.content,
            style: const TextStyle(color: white),
          ),
        ],
      ),
    );
  }
}
