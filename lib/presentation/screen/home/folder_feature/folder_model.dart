// - - - - - - - - - - - - - - - 폴더 데이터 모델 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';

class Folder {
  final String name;
  final Color color;
  final IconData icon;
  final bool isStarred;
  final DateTime createdAt;
  final String? imagePath; // 프로필 이미지 경로 추가

  Folder({
    required this.name,
    required this.color,
    required this.icon,
    this.isStarred = false,
    required this.createdAt,
    this.imagePath, // nullable 처리
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
      'isStarred': isStarred,
      'createdAt': createdAt.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      isStarred: json['isStarred'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      imagePath: json['imagePath'],
    );
  }
}
