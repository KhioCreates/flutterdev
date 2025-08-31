import 'package:flutter/material.dart';

class DiaryEntry {
  final Color color;
  final String note;
  final String hashtag;
  final DateTime when;

  DiaryEntry({
    required this.color,
    required this.note,
    required this.hashtag,
    required this.when,
  });

  // July 06, 2025
  String get longDate {
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    final m = months[when.month - 1];
    final d = when.day.toString().padLeft(2, '0');
    final y = when.year.toString();
    return '$m $d, $y';
  }

  // 10:16 PM
  String get hhmmA {
    int h = when.hour;
    final m = when.minute.toString().padLeft(2, '0');
    final am = h < 12;
    h = h % 12; if (h == 0) h = 12;
    return '$h:$m ${am ? "AM" : "PM"}';
  }
}
