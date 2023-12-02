import 'package:testing/exports.dart';

class Note {
  final String? id;
  final String title;
  final String content;
  final NoteColor color;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final String userId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.userId,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'color': color.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json, String id) {
    return Note(
      id: id,
      title: json['title'],
      color: NoteColor.values
          .firstWhere((element) => element.name == json['color']),
      content: json['content'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    NoteColor? color,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? userId,
    List<Attachment>? attachments,
    List<String>? tags,
    String? category,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, color: $color, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId)';
  }
}
