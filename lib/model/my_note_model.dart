import 'package:intl/intl.dart';

class NotesNames {
  static const String id = "id";
  static const String uniqueId = "uniqueId";
  static const String pin = "pin";
  static const String title = "title";
  static const String content = "content";
  static const String isArchived = "isArchived";
  static const String createdTime = "createdTime";
  static const String tableName = "Notes";

  static final List<String> values = [
    id,
    pin,
    title,
    uniqueId,
    content,
    createdTime,
    isArchived,
  ];
}

class Note {
  final int? id;
  final bool pin;
  final String uniqueId;
  final bool isArchived;
  final String title;
  final String content;
  final DateTime createdTime;

// Constructer
  const Note(
      {this.id,
      required this.pin,
      required this.title,
      required this.isArchived,
      required this.content,
      required this.uniqueId,
      required this.createdTime});

  Note copy({
    int? id,
    bool? pin,
    bool? isArchived,
    String? uniqueId,
    String? title,
    String? content,
    DateTime? createdTime,
  }) {
    return Note(
        id: id ?? this.id,
        pin: pin ?? this.pin,
        title: title ?? this.title,
        uniqueId: uniqueId ?? this.uniqueId,
        content: content ?? this.content,
        createdTime: createdTime ?? this.createdTime,
        isArchived: isArchived ?? this.isArchived);
  }

  static Note fromJson(Map<String, Object?> json) {
    DateTime createdTime;
    try {
      createdTime = DateTime.parse(json[NotesNames.createdTime] as String);
    } catch (e) {
      print(
          "Error in parsing date: ${json[NotesNames.createdTime]}, trying alternative format...");
      try {
        createdTime = DateFormat('dd MMM yyyy')
            .parse(json[NotesNames.createdTime] as String);
      } catch (e) {
        print(
            "Error in parsing date with alternative format: ${json[NotesNames.createdTime]}");
        rethrow;
      }
    }
    return Note(
        id: json[NotesNames.id] as int?,
        pin: json[NotesNames.pin] == 1,
        title: json[NotesNames.title] as String,
        content: json[NotesNames.content] as String,
        createdTime: createdTime,
        isArchived: json[NotesNames.isArchived] == 1,
        uniqueId: json[NotesNames.uniqueId] as String);
  }

  Map<String, Object?> toJson() {
    return {
      NotesNames.id: id,
      NotesNames.pin: pin ? 1 : 0,
      NotesNames.isArchived: isArchived ? 1 : 0,
      NotesNames.title: title,
      NotesNames.uniqueId: uniqueId,
      NotesNames.content: content,
      NotesNames.createdTime: createdTime.toIso8601String()
    };
  }
}
