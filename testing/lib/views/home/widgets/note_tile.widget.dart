import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class NoteTile extends ConsumerWidget {
  const NoteTile({
    super.key,
    required this.note,
    this.onTap,
  });

  final Note note;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    return Card(
      color: note.color == NoteColor.none
          ? null
          : isDarkMode
              ? note.color.color.withAlpha(100)
              : note.color.color.withAlpha(225),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: (note.content.length % 5 + 1) + 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
