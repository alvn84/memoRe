class Memo {
  final int? id; // 서버에서 부여한 고유 식별자
  final String title;
  final String content;
  final String imageUrl;
  final int folderId; // ✅ 서버 연동용 folderId (정수)

  Memo({
    this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.folderId, // ✅ 변경됨
  });

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
        id: json['id'],
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        folderId: json['folderId'] ?? 0, // 서버 응답에 따라 조정
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'folderId': folderId, // ✅ 반드시 포함
      };

  Memo copyWith({
    int? id,
    String? title,
    String? content,
    String? imageUrl,
    int? folderId, // ✅ 함께 복사 가능
  }) {
    return Memo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      folderId: folderId ?? this.folderId,
    );
  }
}
