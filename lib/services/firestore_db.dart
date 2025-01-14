import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_keep_notes_clone/model/my_note_model.dart';
import 'package:google_keep_notes_clone/services/db.dart';
import 'package:google_keep_notes_clone/services/login_info.dart';

class FireDB {
  // Create, Read, Update & Delete
  final FirebaseAuth _auth = FirebaseAuth.instance;

  createNewNoteFirestore(Note note, String string) async {
    LocalDataSaver.getSyncSettings().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(currentUser!.email)
            .collection("usernotes")
            .doc(note.uniqueId)
            .set({
          "Title": note.title,
          "content": note.content,
          "uniqueId": note.uniqueId,
          "date": note.createdTime,
        }).then((_) {
          print("Data added successfully");
        });
      } else {
        print("Sync is off");
      }
    });
  }

  getAllStoredNotes() async {
    final User? currentUser = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(currentUser!.email)
        .collection("usernotes")
        .orderBy("date")
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        Map note = result.data();

        NotesDatabase.instance.insertEntry(Note(
          title: note["Title"],
          content: note["content"],
          createdTime: note["date"],
          pin: false,
          isArchived: false,
          uniqueId: note["uniqueId"],
        )); //Add Notes In Database
      }
    });
  }

  updateNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSettings().then((isSyncOn) async {
      print(isSyncOn);
      if (isSyncOn.toString() == "true") {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(currentUser!.email)
            .collection("usernotes")
            .doc(note.uniqueId.toString())
            .update({
          "Title": note.title.toString(),
          "content": note.content
        }).then((_) {
          print("Data Updated Successfully");
        });
      } else {
        print("Sync is off");
      }
    });
  }

  deleteNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSettings().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        final User? currentUser = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(currentUser!.email)
            .collection("usernotes")
            .doc(note.uniqueId.toString())
            .delete()
            .then((_) {
          print("Data Deleted Successfully");
        });
      } else {
        print("Sync is off");
      }
    });
  }
}
