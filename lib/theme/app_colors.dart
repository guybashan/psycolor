import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  // Light, airy canvas
  static const background = Color(0xFFFFF7FB);
  static const backgroundAlt = Color(0xFFF0F7FF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceTint = Color(0xFFFDF2FF);

  // Rich readable text on light backgrounds
  static const textPrimary = Color(0xFF2B1B45);
  static const textSecondary = Color(0xFF6B5A7A);

  // Vivid brand accents
  static const accent = Color(0xFFE040FB);
  static const accentSecondary = Color(0xFF7C4DFF);
  static const accentTertiary = Color(0xFF00B4D8);
  static const glassBorder = Color(0x33A855F7);

  // Lüscher test palette — saturated and lively
  static const testBlue = Color(0xFF2196F3);
  static const testGreen = Color(0xFF22C55E);
  static const testRed = Color(0xFFEF4444);
  static const testYellow = Color(0xFFFACC15);
  static const testViolet = Color(0xFFA855F7);
  static const testBrown = Color(0xFFD97706);
  static const testBlack = Color(0xFF334155);
  static const testGray = Color(0xFF94A3B8);

  // Colorful ambient glows for backgrounds
  static const glowPink = Color(0x66FF6B9D);
  static const glowBlue = Color(0x664FACFE);
  static const glowYellow = Color(0x66FFD93D);
  static const glowViolet = Color(0x66C084FC);
  static const glowOrange = Color(0x66FF9A56);
  static const glowCyan = Color(0x6600D4FF);

  static const spectrumGradient = [
    Color(0xFFFF6B9D),
    Color(0xFFFFC93D),
    Color(0xFF4FACFE),
    Color(0xFFA855F7),
    Color(0xFF34D399),
  ];

  static const heroGradient = [
    Color(0xFFFF6B9D),
    Color(0xFF9B5DE5),
    Color(0xFF00BBF9),
  ];

  static const buttonGradient = [
    Color(0xFFFF6B9D),
    Color(0xFF9B5DE5),
    Color(0xFF00BBF9),
  ];
}

enum TestColorId {
  blue,
  green,
  red,
  yellow,
  violet,
  brown,
  black,
  gray,
}

extension TestColorIdX on TestColorId {
  String get name {
    switch (this) {
      case TestColorId.blue:
        return 'Blue';
      case TestColorId.green:
        return 'Green';
      case TestColorId.red:
        return 'Red';
      case TestColorId.yellow:
        return 'Yellow';
      case TestColorId.violet:
        return 'Violet';
      case TestColorId.brown:
        return 'Brown';
      case TestColorId.black:
        return 'Black';
      case TestColorId.gray:
        return 'Gray';
    }
  }

  Color get color {
    switch (this) {
      case TestColorId.blue:
        return AppColors.testBlue;
      case TestColorId.green:
        return AppColors.testGreen;
      case TestColorId.red:
        return AppColors.testRed;
      case TestColorId.yellow:
        return AppColors.testYellow;
      case TestColorId.violet:
        return AppColors.testViolet;
      case TestColorId.brown:
        return AppColors.testBrown;
      case TestColorId.black:
        return AppColors.testBlack;
      case TestColorId.gray:
        return AppColors.testGray;
    }
  }

  String get trait {
    switch (this) {
      case TestColorId.blue:
        return 'Calm, depth, need for peace';
      case TestColorId.green:
        return 'Persistence, self-assertion';
      case TestColorId.red:
        return 'Vitality, drive';
      case TestColorId.yellow:
        return 'Optimism, expectation';
      case TestColorId.violet:
        return 'Identification, dignity';
      case TestColorId.brown:
        return 'Physical comfort, stability';
      case TestColorId.black:
        return 'Renunciation, independence';
      case TestColorId.gray:
        return 'Neutrality, non-involvement';
    }
  }

  String get storageKey => name.toLowerCase();
}

TestColorId testColorFromKey(String key) {
  return TestColorId.values.firstWhere(
    (c) => c.storageKey == key,
    orElse: () => TestColorId.blue,
  );
}

List<TestColorId> get defaultColorOrder => TestColorId.values.toList();

/// Fresh random layout each pass — reduces position bias; scoring uses final rank only.
List<TestColorId> shuffledColorOrder([Random? random]) {
  final order = List<TestColorId>.from(defaultColorOrder);
  order.shuffle(random ?? Random());
  return order;
}
