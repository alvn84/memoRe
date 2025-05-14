// memo/model/memo.dart

class Memo {
  final String title;
  final String contentJson; // flutter_quill delta 형식 문자열
  final String writtenDate; // yyyy.MM.dd
  final String modifiedDate; // yyyy.MM.dd

  Memo({
    required this.title,
    required this.contentJson,
    required this.writtenDate,
    required this.modifiedDate,
  });

  // 나중에 서버 연동 시 사용할 수 있는 변환 메서드
  Map<String, dynamic> toJson() => {
        'title': title,
        'contentJson': contentJson,
        'writtenDate': writtenDate,
        'modifiedDate': modifiedDate,
      };

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
        title: json['title'] ?? '',
        contentJson: json['contentJson'] ?? '',
        writtenDate: json['writtenDate'] ?? '',
        modifiedDate: json['modifiedDate'] ?? '',
      );

  Memo copyWith({
    String? title,
    String? contentJson,
    String? writtenDate,
    String? modifiedDate,
  }) {
    return Memo(
      title: title ?? this.title,
      contentJson: contentJson ?? this.contentJson,
      writtenDate: writtenDate ?? this.writtenDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
    );
  }
}
