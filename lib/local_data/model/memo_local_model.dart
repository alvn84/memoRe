class LocalMemo {
  final int? id;
  final String title;
  final String content;
  final String imageUrl;
  final int? folderId;
  final DateTime createdAt;

  LocalMemo({
    this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.folderId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'folderId': folderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LocalMemo.fromMap(Map<String, dynamic> map) {
    return LocalMemo(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      folderId: map['folderId'] as int?,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}