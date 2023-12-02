import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

enum NoteColor {
  none,
  red,
  orange,
  yellow,
  green,
  teal,
  blue,
  darkBlue,
  purple,
  pink,
  brown,
}

extension NoteColorExtension on NoteColor {
  Color get color {
    switch (this) {
      case NoteColor.red:
        return noteColors[NoteColor.red]!;
      case NoteColor.orange:
        return noteColors[NoteColor.orange]!;
      case NoteColor.yellow:
        return noteColors[NoteColor.yellow]!;
      case NoteColor.green:
        return noteColors[NoteColor.green]!;
      case NoteColor.teal:
        return noteColors[NoteColor.teal]!;
      case NoteColor.blue:
        return noteColors[NoteColor.blue]!;
      case NoteColor.darkBlue:
        return noteColors[NoteColor.darkBlue]!;
      case NoteColor.purple:
        return noteColors[NoteColor.purple]!;
      case NoteColor.pink:
        return noteColors[NoteColor.pink]!;
      case NoteColor.brown:
        return noteColors[NoteColor.brown]!;
      default:
        return noteColors[NoteColor.none]!;
    }
  }
}
