import 'package:testing/exports.dart';

final allNotesStream = StreamProvider<List<Note>>(
  (ref) {
    final notesStream = NotesDatabase.instance.streamNotes();

    return notesStream;
  },
);
