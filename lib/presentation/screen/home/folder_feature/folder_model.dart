// - - - - - - - - - - - - - - - 폴더 데이터 모델 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';

class Folder {
  final int? id;
  final String name;
  final Color color;
  final IconData icon;
  final bool isStarred;
  final DateTime createdAt;
  final String? imageUrl; // 프로필 이미지 경로 추가

  // ✅ 새로 추가된 필드
  final String? location;
  final DateTime? startDate;
  final DateTime? endDate;

  Folder({
    this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.isStarred = false,
    required this.createdAt,
    this.imageUrl, // nullable 처리
    this.location,
    this.startDate,
    this.endDate,
  });

  Folder copyWith({
    int? id,
    String? name,
    Color? color,
    IconData? icon,
    bool? isStarred,
    DateTime? createdAt,
    String? imageUrl,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isStarred: isStarred ?? this.isStarred,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json) {
    try {
      final rawColor = json['color'];
      final int colorInt = rawColor is int
          ? rawColor
          : int.tryParse(rawColor.toString(), radix: 16) ?? 0xFFFFE082;

      return Folder(
        id: json['id'],
        name: json['name'] ?? '',
        color: Color(colorInt),
        icon: IconData(
          (json['icon'] ?? Icons.folder.codePoint),
          fontFamily: 'MaterialIcons',
        ),
        isStarred: json['starred'] ?? false,
        // ✅ 여기가 핵심!
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        imageUrl: (json['imageUrl'] == null || json['imageUrl'] == "null")
            ? null
            : json['imageUrl'],
        location: json['location'],
        startDate: json['startDate'] != null
            ? DateTime.tryParse(json['startDate'])
            : null,
        endDate:
            json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      );
    } catch (e) {
      print('❌ Folder 파싱 오류: $e\n원본 JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
      'starred': isStarred, // ✅ 여기도!
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'location': location,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
