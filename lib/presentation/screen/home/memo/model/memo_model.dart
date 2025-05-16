class Memo {
  final int? id; // ← 서버에서 부여한 고유 식별자
  final String title;
  final String content;
  final String imageUrl;
  final String storagePath;

  Memo({
    this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.storagePath,
  });

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        storagePath: json['storagePath'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        // id는 생성 시 서버가 자동 생성하므로 보낼 필요 없을 수 있음
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'storagePath': storagePath,
      };

  Memo copyWith({
    int? id,
    String? title,
    String? content,
    String? imageUrl,
    String? storagePath,
  }) {
    return Memo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      storagePath: storagePath ?? this.storagePath,
    );
  }
}
