import 'package:google_keep_notes_clone/model/my_note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Notes.db');
    return _database;
  }

  Future<Database> _initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE Notes(
    ${NotesNames.id} $idType,
    ${NotesNames.pin} $boolType,
    ${NotesNames.isArchived} $boolType,
    ${NotesNames.title} $textType,
    ${NotesNames.content} $textType,
    ${NotesNames.createdTime} $textType
    )
    ''');
  }

  Future<Note?> insertEntry(Note note) async {
    final db = await instance.database;
    final id = await db!.insert(NotesNames.tableName, note.toJson());

    return note.copy(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = '${NotesNames.createdTime} ASC';
    final queryResult = await db!.query(NotesNames.tableName, orderBy: orderBy);

    return queryResult.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note?> readOneNote(int id) async {
    final db = await instance.database;
    final map = await db!.query(NotesNames.tableName,
        columns: NotesNames.values,
        where: '${NotesNames.id}= ?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    } else {
      return null;
    }
  }

  Future updateNote(Note note) async {
    final db = await instance.database;
    await db!.update(NotesNames.tableName, note.toJson(),
        where: '${NotesNames.id}= ?', whereArgs: [note.id]);
  }

  Future pinNote(Note? note) async {
    final db = await instance.database;
    await db!.update(NotesNames.tableName, {NotesNames.pin: !note!.pin ? 1 : 0},
        where: '${NotesNames.id}= ?', whereArgs: [note.id]);
  }

  Future archivedNotes(Note? note) async {
    final db = await instance.database;
    await db!.update(NotesNames.tableName,
        {NotesNames.isArchived: !note!.isArchived ? 1 : 0},
        where: '${NotesNames.id}= ?', whereArgs: [note.id]);
  }

  Future<List<int>> getNoteString(String query) async {
    final db = await instance.database;
    final result = await db!.query(NotesNames.tableName);
    List<int> resultIds = [];
    for (var element in result) {
      if (element["title"].toString().toLowerCase().contains(query) ||
          element["content"].toString().toLowerCase().contains(query)) {
        resultIds.add(element["id"] as int);
      }
    }

    return resultIds;
  }

  Future deleteNote(Note? note) async {
    final db = await instance.database;
    return await db!.delete(NotesNames.tableName,
        where: '${NotesNames.id} = ?', whereArgs: [note?.id]);
  }

  Future<void> deleteAllNotes() async {
    final db = await instance.database;
    await db?.delete('Notes');
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'Notes.db');

    // Close the database if open
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    // Delete the database
    await deleteDatabase(path);

    // Recreate the database
    await _initializeDB('Notes.db');
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
