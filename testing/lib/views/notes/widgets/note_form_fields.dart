import 'package:flutter/material.dart';

class NoteFormField extends StatelessWidget {
  const NoteFormField({
    super.key,
    required this.titleController,
    required this.hintText,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.expands = false,
    this.fillColor,
    this.readOnly = false,
  });

  final TextEditingController titleController;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final bool expands;
  final Color? fillColor;
  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      expands: expands,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: fillColor ?? Theme.of(context).scaffoldBackgroundColor,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
