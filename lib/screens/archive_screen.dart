import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_notes_clone/model/my_note_model.dart';
import 'package:google_keep_notes_clone/screens/new_note_screen.dart';
import 'package:google_keep_notes_clone/screens/notes_screen.dart';
import 'package:google_keep_notes_clone/screens/search_screen.dart';
import 'package:google_keep_notes_clone/services/db.dart';
import 'package:google_keep_notes_clone/side_menu_bar.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  List<Note> notesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllNotes();
  }

  Future<void> getAllNotes() async {
    notesList = await NotesDatabase.instance.readAllArchiveNotes();
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: const SideMenuBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewNoteScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 45),
      ),
      backgroundColor: bgColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 10),
                      _buildSectionTitle("Archived notes "),
                      const SizedBox(height: 20),
                      _buildNotesGrid(),
                      // _buildSectionTitle("LIST VIEW]"),
                      // _buildNotesList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 55,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: white),
              ),
              const SizedBox(width: 16),
// Gesture Detector
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
                  width: 190,
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
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.grid_view, color: white),
              ),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Text(
        title,
        style: TextStyle(
          color: white.withOpacity(0.5),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotesGrid() {
    return MasonryGridView.builder(
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
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
              builder: (context) => NoteViewScreen(note: notesList[index]),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notesList[index].title,
                style: const TextStyle(
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                notesList[index].content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildNotesList() {
  //   return ListView.builder(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: notesList.length,
  //     itemBuilder: (context, index) => Container(
  //       padding: const EdgeInsets.all(10),
  //       margin: const EdgeInsets.only(bottom: 10),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: white.withOpacity(0.4)),
  //         borderRadius: BorderRadius.circular(7),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             notesList[index].title,
  //             style: const TextStyle(
  //               color: white,
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Text(
  //             notesList[index].content,
  //             maxLines: 5,
  //             overflow: TextOverflow.ellipsis,
  //             style: const TextStyle(color: white),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
