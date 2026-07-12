import 'package:flutter/material.dart';

/// One mood check-in: the color a user picked to describe their day.
class MoodEntry {
  const MoodEntry({
    required this.dateKey,
    required this.family,
    required this.tone,
    required this.colorValue,
    required this.createdAt,
  });

  /// Calendar day, 'yyyy-MM-dd' in local time. One entry per day.
  final String dateKey;

  /// Hue family, e.g. 'red', 'teal', 'neutral'.
  final String family;

  /// 'bright' | 'soft' | 'deep'.
  final String tone;

  /// ARGB of the exact swatch picked, for display.
  final int colorValue;

  final DateTime createdAt;

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() => {
        'dateKey': dateKey,
        'family': family,
        'tone': tone,
        'colorValue': colorValue,
        'createdAt': createdAt.toIso8601String(),
      };

  factory MoodEntry.fromMap(Map<dynamic, dynamic> map) => MoodEntry(
        dateKey: map['dateKey'] as String,
        family: map['family'] as String,
        tone: map['tone'] as String,
        colorValue: map['colorValue'] as int,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );

  static String dateKeyFor(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }
}
