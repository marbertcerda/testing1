import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class NoteListView extends ConsumerWidget {
  const NoteListView({
    super.key,
    required this.query,
  });

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ref.watch(allNotesStream).when(
            data: (notes) {
              if (query.isNotEmpty) {
                notes = _searchNote(
                  notes,
                  query,
                );
              }

              if (query.isNotEmpty && notes.isEmpty) {
                return const Center(
                  child: Text('No notes found.'),
                );
              }

              if (notes.isEmpty) {
                return const Center(
                  child: Text('No notes yet.'),
                );
              }

              return MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: notes.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final Note note = notes[index];
                  return NoteTile(
                    note: note,
                    onTap: () => goToNoteView(note),
                  );
                },
              );
            },
            error: (error, stackTrace) {
              print(error);
              print(stackTrace);
              return const Center(
                child: Text(
                  'Error fetching notes.',
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }

  List<Note> _searchNote(List<Note> notes, String query) {
    return notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
