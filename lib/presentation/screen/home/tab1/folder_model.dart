import 'package:flutter/material.dart';

class Folder {
  final String name;
  final Color color;
  final IconData icon;
  final bool isStarred;

  Folder({
    required this.name,
    required this.color,
    required this.icon,
    this.isStarred = false,
  });

  // JSON으로 변환 (SharedPreferences에 저장할 때 사용)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color.value, // Color는 value(int)로 저장
      'icon': icon.codePoint, // IconData는 codePoint로 저장
      'isStarred': isStarred,
    };
  }

  // JSON에서 복구 (SharedPreferences에서 불러올 때 사용)
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      isStarred: json['isStarred'] ?? false,
    );
  }
}