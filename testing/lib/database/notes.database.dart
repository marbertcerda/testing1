import 'package:testing/exports.dart';

class NotesDatabase {
  const NotesDatabase._();

  static const NotesDatabase _instance = NotesDatabase._();
  static NotesDatabase get instance => _instance;

  static final _firestore = FirebaseFirestore.instance;
  static final _notes = _firestore.collection('notes');
  static final _currenUser = AuthService.instance.currentUser;

  Stream<List<Note>> streamNotes() {
    return _notes
        .where('userId', isEqualTo: _currenUser!.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromJson(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> createNote({
    required Note note,
  }) async {
    await _notes.add(
      note.copyWith(userId: _currenUser!.uid).toJson(),
    );
  }

  Future<void> updateNote({
    required Note note,
  }) async {
    await _notes.doc(note.id).update(
          note.toJson(),
        );
  }

  Future<void> deleteNote({
    required Note note,
  }) async {
    await _notes.doc(note.id).delete();
  }
}
