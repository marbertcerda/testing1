import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class SaveNoteButton extends ConsumerWidget {
  const SaveNoteButton({
    super.key,
    required this.editMode,
    required this.isEmpty,
    required this.onPressed,
  });

  final bool editMode;
  final bool isEmpty;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    return Visibility(
      visible: editMode || !isEmpty,
      child: TextButton.icon(
        style: Theme.of(context).textButtonTheme.style!.copyWith(
              foregroundColor: MaterialStatePropertyAll(
                isDarkMode ? Colors.white : Colors.black,
              ),
            ),
        onPressed: onPressed,
        icon: const Icon(Icons.check),
        label: const Text('Save'),
      ),
    );
  }
}
