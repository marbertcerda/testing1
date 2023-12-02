class Attachment {
  final String name;
  final String url;
  final String type;

  const Attachment({
    required this.name,
    required this.url,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'type': type,
    };
  }

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      name: map['name'],
      url: map['url'],
      type: map['type'],
    );
  }

  Attachment copyWith({
    String? name,
    String? url,
    String? type,
  }) {
    return Attachment(
      name: name ?? this.name,
      url: url ?? this.url,
      type: type ?? this.type,
    );
  }
}
