import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_notes_clone/model/my_note_model.dart';
import 'package:google_keep_notes_clone/screens/notes_screen.dart';
import 'package:google_keep_notes_clone/services/db.dart';
import 'package:google_keep_notes_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  List<Note> searchResultNotes = [];
  List<int> searchResultIDs = [];

  void searchResults(String query) async {
    searchResultNotes.clear();
    setState(() => isLoading = true);

    final resultIDs = await NotesDatabase.instance.getNoteString(query);
    List<Note?> searchResultNotesLocal = []; //[nOTE1, nOTE2]
    resultIDs.forEach((element) async {
      final searchNote = await NotesDatabase.instance.readOneNote(element);
      searchResultNotesLocal.add(searchNote);
      if (searchNote != null) {
        setState(() {
          searchResultNotes.add(searchNote);
        });
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: white.withOpacity(0.1),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_outlined,
                        color: Colors.white),
                  ),
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search your notes',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.8)),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        searchResults(value.toLowerCase());
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else if (searchResultNotes.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "No results found.",
                  style: TextStyle(color: white.withOpacity(0.7), fontSize: 16),
                ),
              )
            else
              Expanded(child: results()),
          ],
        ),
      ),
    );
  }

  Widget results() {
    return MasonryGridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: searchResultNotes.length,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NoteViewScreen(note: searchResultNotes[index]),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: white.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                searchResultNotes[index].title,
                style: const TextStyle(
                  color: white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                searchResultNotes[index].content.length > 250
                    ? "${searchResultNotes[index].content.substring(0, 250)}..."
                    : searchResultNotes[index].content,
                style: const TextStyle(color: white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
