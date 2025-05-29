import 'package:flutter/material.dart';

enum TravelPurpose {
  tourism('TOURISM'),
  business('BUSINESS'),
  relaxation('RELAXATION'),
  other('OTHER');

  final String value;

  const TravelPurpose(this.value);

  static TravelPurpose? fromString(String? value) {
    if (value == null) return null;
    return TravelPurpose.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TravelPurpose.other,
    );
  }
}

class Folder {
  final int? id;
  final String name;
  final Color color;
  final IconData icon;
  final bool isStarred;
  final DateTime createdAt;
  final String? imageUrl;

  // ✅ 새로 추가된 필드들
  final String? location;
  final DateTime? startDate;
  final DateTime? endDate;
  final TravelPurpose? purpose; // ← 여기에 목적 추가
  final String? aiGuide; // 🔥 AI 가이드 필드 추가

  Folder({
    this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.isStarred = false,
    required this.createdAt,
    this.imageUrl,
    this.location,
    this.startDate,
    this.endDate,
    this.purpose,
    this.aiGuide,
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
    TravelPurpose? purpose,
    String? aiGuide,
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
      purpose: purpose ?? this.purpose,
      aiGuide: aiGuide ?? this.aiGuide,
    );
  }

  factory Folder.fromJson(Map<String, dynamic> json) {
    try {
      final rawColor = json['color'];
      final int colorInt = rawColor is int
          ? rawColor
          : int.tryParse(rawColor.toString(), radix: 16) ?? 0xFFECEFF1;

      return Folder(
        id: json['id'],
        name: json['name'] ?? '',
        color: Color(colorInt),
        icon: IconData(
          (json['icon'] ?? Icons.folder.codePoint),
          fontFamily: 'MaterialIcons',
        ),
        isStarred: json['starred'] ?? false,
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
        purpose: TravelPurpose.fromString(json['purpose']),
        aiGuide: json['aiGuide'],
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
      'starred': isStarred,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'location': location,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'purpose': purpose?.value,
      'aiGuide': aiGuide,
    };
  }
}
