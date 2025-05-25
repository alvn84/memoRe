import 'package:flutter/material.dart';

class Folder {
  final String name;
  final Color color;
  final IconData icon;
  final bool isStarred;
  final DateTime createdAt;
  final String? imagePath; // 프로필 이미지 경로 추가
  final String? destination;
  final DateTimeRange? dateRange;

  Folder({
    required this.name,
    required this.color,
    required this.icon,
    this.isStarred = false,
    required this.createdAt,
    this.imagePath, // nullable 처리
    this.destination,
    this.dateRange,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
      'isStarred': isStarred,
      'createdAt': createdAt.toIso8601String(),
      'imagePath': imagePath,
      'destination': destination,
      'dateStart': dateRange?.start.toIso8601String(),
      'dateEnd': dateRange?.end.toIso8601String(),
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
      destination: json['destination'],
      dateRange: (json['dateStart'] != null && json['dateEnd'] != null)
          ? DateTimeRange(
        start: DateTime.parse(json['dateStart']),
        end: DateTime.parse(json['dateEnd']),
      )
          : null,
    );
  }
}