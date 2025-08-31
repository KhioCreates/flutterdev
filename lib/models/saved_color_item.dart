import 'package:flutter/material.dart';

class SavedColorItem {
  final Color color;
  final String name;
  final DateTime savedAt;

  SavedColorItem({
    required this.color,
    required this.name,
    required this.savedAt,
  });

  String get hex =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  String get rgb => '(${color.red},${color.green},${color.blue})';
}
