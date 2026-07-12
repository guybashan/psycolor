import 'dart:math';

import 'package:flutter/material.dart';
import 'package:psycolor/theme/oklch.dart';

/// A single tile in the hue-ordering test.
/// [correctIndex] is its position in the true hue sequence (0-based,
/// including the fixed anchors at both ends).
class HueTile {
  const HueTile({required this.correctIndex, required this.color});

  final int correctIndex;
  final Color color;
}

/// Generates tiles and scores arrangements for the Farnsworth–Munsell-style
/// hue discrimination test.
///
/// Colors are generated in OKLCh so that equal hue steps are perceptually
/// even — a property sRGB/HSV interpolation does not have.
class HueTestService {
  const HueTestService();

  /// Total tiles shown, including one fixed anchor at each end.
  static const int tileCount = 20;

  /// Lightness/chroma held constant so hue is the only cue.
  static const double _lightness = 0.75;
  static const double _chroma = 0.12;

  /// Hue arc endpoints in degrees. Spans teal → violet, a range where
  /// discrimination differences between people are pronounced.
  static const double _hueStart = 130;
  static const double _hueEnd = 280;

  /// Tiles in correct hue order.
  List<HueTile> orderedTiles() {
    final tiles = <HueTile>[];
    for (var i = 0; i < tileCount; i++) {
      final hue = _hueStart + (_hueEnd - _hueStart) * i / (tileCount - 1);
      tiles.add(HueTile(correctIndex: i, color: oklchToColor(_lightness, _chroma, hue)));
    }
    return tiles;
  }

  /// Tiles with the middle section shuffled; anchors stay at both ends.
  /// Never returns an already-solved arrangement.
  List<HueTile> shuffledTiles([Random? random]) {
    final rng = random ?? Random();
    final tiles = orderedTiles();
    final middle = tiles.sublist(1, tileCount - 1);
    do {
      middle.shuffle(rng);
    } while (_isSorted(middle));
    return [tiles.first, ...middle, tiles.last];
  }

  bool _isSorted(List<HueTile> tiles) {
    for (var i = 1; i < tiles.length; i++) {
      if (tiles[i].correctIndex < tiles[i - 1].correctIndex) return false;
    }
    return true;
  }

  /// Displacement of each tile from its correct position, in the order the
  /// tiles are currently arranged.
  List<int> displacements(List<HueTile> arrangement) {
    return [
      for (var i = 0; i < arrangement.length; i++)
        (arrangement[i].correctIndex - i).abs(),
    ];
  }

  /// Total error: sum of displacements (Spearman footrule distance).
  /// 0 means a perfect arrangement.
  int totalError(List<HueTile> arrangement) {
    return displacements(arrangement).fold(0, (a, b) => a + b);
  }

  /// Worst possible error for the movable tiles (full reversal).
  int get maxError {
    final n = tileCount - 2; // movable tiles
    return n * n ~/ 2;
  }

  /// Accuracy in [0, 100]: 100 = perfect, 0 = fully reversed.
  int accuracy(List<HueTile> arrangement) {
    final err = totalError(arrangement);
    return ((1 - err / maxError) * 100).round().clamp(0, 100);
  }

  /// Qualitative band for a total error, mirroring how FM-100 results are
  /// grouped into superior / average / low discrimination.
  String band(int error) {
    if (error == 0) return 'Superior discrimination';
    if (error <= 4) return 'Excellent discrimination';
    if (error <= 14) return 'Typical discrimination';
    if (error <= 32) return 'Below-average discrimination';
    return 'Low discrimination';
  }

}
