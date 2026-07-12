import 'dart:math';

import 'package:flutter/material.dart';

/// OKLCh → sRGB conversion.
/// Reference: Björn Ottosson, "A perceptual color space for image
/// processing" (https://bottosson.github.io/posts/oklab/).
///
/// If the requested chroma is outside the sRGB gamut for a hue, it is walked
/// down until it fits, so lightness stays constant.
Color oklchToColor(double lightness, double chroma, double hueDeg) {
  var c = chroma;
  List<double>? rgb = _tryOklch(lightness, c, hueDeg);
  while (rgb == null && c > 0) {
    c -= 0.005;
    rgb = _tryOklch(lightness, c, hueDeg);
  }
  rgb ??= [0.5, 0.5, 0.5];
  return Color.fromARGB(
    255,
    (rgb[0] * 255).round(),
    (rgb[1] * 255).round(),
    (rgb[2] * 255).round(),
  );
}

/// Returns sRGB channels in [0,1], or null when out of gamut.
List<double>? _tryOklch(double lightness, double chroma, double hueDeg) {
  final h = hueDeg * pi / 180;
  final a = chroma * cos(h);
  final b = chroma * sin(h);

  final l_ = lightness + 0.3963377774 * a + 0.2158037573 * b;
  final m_ = lightness - 0.1055613458 * a - 0.0638541728 * b;
  final s_ = lightness - 0.0894841775 * a - 1.2914855480 * b;

  final l = l_ * l_ * l_;
  final m = m_ * m_ * m_;
  final s = s_ * s_ * s_;

  final rLin = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s;
  final gLin = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s;
  final bLin = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s;

  const eps = 0.0005;
  if (rLin < -eps || rLin > 1 + eps) return null;
  if (gLin < -eps || gLin > 1 + eps) return null;
  if (bLin < -eps || bLin > 1 + eps) return null;

  return [
    _linearToSrgb(rLin.clamp(0, 1).toDouble()),
    _linearToSrgb(gLin.clamp(0, 1).toDouble()),
    _linearToSrgb(bLin.clamp(0, 1).toDouble()),
  ];
}

double _linearToSrgb(double c) {
  return c <= 0.0031308 ? 12.92 * c : 1.055 * pow(c, 1 / 2.4) - 0.055;
}
