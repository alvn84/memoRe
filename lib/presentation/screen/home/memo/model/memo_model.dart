class Memo {
  final int? id; // 서버에서 부여한 고유 식별자
  final String title;
  final String content;
  final String imageUrl;
  final int? folderId; // 서버 연동용 folderId
  final String? updatedAt;
  final bool isStarred; // ⭐️ 즐겨찾기 여부

  Memo({
    this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    this.folderId,
    this.updatedAt,
    this.isStarred = false, // 기본값 false
  });

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
        id: json['id'],
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        folderId: json['folderId'] ?? 0,
        updatedAt: json['updatedAt'],
        isStarred: json['starred'] ?? false, // 서버 필드명은 starred
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'folderId': folderId,
        'starred': isStarred,
      };

  Memo copyWith({
    int? id,
    String? title,
    String? content,
    String? imageUrl,
    int? folderId,
    String? updatedAt,
    bool? isStarred,
  }) {
    return Memo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      folderId: folderId ?? this.folderId,
      updatedAt: updatedAt ?? this.updatedAt,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}
