import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psycolor/models/mood_entry.dart';
import 'package:psycolor/theme/oklch.dart';

/// One selectable swatch on the check-in grid.
class MoodSwatch {
  const MoodSwatch({
    required this.family,
    required this.tone,
    required this.color,
  });

  final String family;
  final String tone;
  final Color color;
}

/// Palette, persistence, and trend analysis for the daily mood check-in.
///
/// The design follows the idea behind the Manchester Color Wheel: color as a
/// low-friction way to express current state, made meaningful by tracking
/// choices over time rather than interpreting any single pick.
class MoodService {
  MoodService(this._box);

  final Box<dynamic> _box;
  static const _entriesKey = 'entries';

  /// Hue families and their OKLCh hue angle. 'neutral' is handled apart.
  static const Map<String, double> _familyHues = {
    'red': 25,
    'orange': 55,
    'yellow': 95,
    'green': 145,
    'teal': 195,
    'blue': 255,
    'violet': 295,
    'pink': 345,
  };

  /// Warm families for the warmth trend.
  static const Set<String> warmFamilies = {'red', 'orange', 'yellow', 'pink'};

  /// Tone → (lightness, chroma) for hue families.
  static const Map<String, (double, double)> _tones = {
    'bright': (0.72, 0.15),
    'soft': (0.84, 0.06),
    'deep': (0.48, 0.10),
  };

  /// Tone → lightness for neutrals (chroma 0).
  static const Map<String, double> _neutralTones = {
    'bright': 0.95,
    'soft': 0.62,
    'deep': 0.30,
  };

  /// Energy weight per tone, used for the bright/muted trend.
  static const Map<String, double> toneEnergy = {
    'bright': 1.0,
    'soft': 0.55,
    'deep': 0.15,
  };

  /// Full grid: 8 hue families + neutral row, 3 tones each (27 swatches),
  /// family-major so each grid row is one family across its three tones.
  List<MoodSwatch> palette() {
    final swatches = <MoodSwatch>[];
    for (final family in _familyHues.keys) {
      for (final tone in _tones.keys) {
        final (l, c) = _tones[tone]!;
        swatches.add(MoodSwatch(
          family: family,
          tone: tone,
          color: oklchToColor(l, c, _familyHues[family]!),
        ));
      }
    }
    for (final tone in _neutralTones.keys) {
      swatches.add(MoodSwatch(
        family: 'neutral',
        tone: tone,
        color: oklchToColor(_neutralTones[tone]!, 0, 0),
      ));
    }
    return swatches;
  }

  // ---- persistence ------------------------------------------------------

  List<MoodEntry> getAll() {
    final raw = _box.get(_entriesKey) as List<dynamic>?;
    if (raw == null) return [];
    return raw
        .map((e) => MoodEntry.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.dateKey.compareTo(a.dateKey));
  }

  /// Saves the entry for its calendar day, replacing any earlier pick that day.
  Future<void> save(MoodEntry entry) async {
    final entries = getAll().where((e) => e.dateKey != entry.dateKey).toList();
    entries.insert(0, entry);
    await _box.put(_entriesKey, entries.map((e) => e.toMap()).toList());
  }

  MoodEntry? entryFor(DateTime date) {
    final key = MoodEntry.dateKeyFor(date);
    for (final e in getAll()) {
      if (e.dateKey == key) return e;
    }
    return null;
  }

  // ---- trends -------------------------------------------------------------

  /// Consecutive days with an entry, ending today (or yesterday, so a streak
  /// isn't shown as broken before today's check-in).
  int streak(List<MoodEntry> entries, DateTime today) {
    final keys = entries.map((e) => e.dateKey).toSet();
    var day = today;
    if (!keys.contains(MoodEntry.dateKeyFor(day))) {
      day = day.subtract(const Duration(days: 1));
      if (!keys.contains(MoodEntry.dateKeyFor(day))) return 0;
    }
    var count = 0;
    while (keys.contains(MoodEntry.dateKeyFor(day))) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  List<MoodEntry> _window(
      List<MoodEntry> entries, DateTime today, int fromDaysAgo, int toDaysAgo) {
    final result = <MoodEntry>[];
    for (var d = fromDaysAgo; d < toDaysAgo; d++) {
      final key = MoodEntry.dateKeyFor(today.subtract(Duration(days: d)));
      for (final e in entries) {
        if (e.dateKey == key) result.add(e);
      }
    }
    return result;
  }

  double? _warmRatio(List<MoodEntry> entries) {
    final colored = entries.where((e) => e.family != 'neutral').toList();
    if (colored.isEmpty) return null;
    final warm = colored.where((e) => warmFamilies.contains(e.family)).length;
    return warm / colored.length;
  }

  double? _energy(List<MoodEntry> entries) {
    if (entries.isEmpty) return null;
    final total = entries.fold<double>(0, (sum, e) => sum + toneEnergy[e.tone]!);
    return total / entries.length;
  }

  /// Human-readable observations about the last two weeks of entries.
  /// Only states things the data actually supports.
  List<String> trendLines(List<MoodEntry> entries, DateTime today) {
    final thisWeek = _window(entries, today, 0, 7);
    if (thisWeek.length < 3) {
      return [
        'Check in for a few more days and patterns will start to appear here.',
      ];
    }

    final lastWeek = _window(entries, today, 7, 14);
    final lines = <String>[];

    final warmNow = _warmRatio(thisWeek);
    final warmBefore = _warmRatio(lastWeek);
    if (warmNow != null && warmBefore != null && lastWeek.length >= 3) {
      final delta = warmNow - warmBefore;
      if (delta >= 0.25) {
        lines.add('Your picks ran warmer this week than last.');
      } else if (delta <= -0.25) {
        lines.add('Your picks ran cooler this week than last.');
      }
    } else if (warmNow != null) {
      if (warmNow >= 0.7) {
        lines.add('Mostly warm colors this week.');
      } else if (warmNow <= 0.3) {
        lines.add('Mostly cool colors this week.');
      }
    }

    final energyNow = _energy(thisWeek);
    final energyBefore = _energy(lastWeek);
    if (energyNow != null && energyBefore != null && lastWeek.length >= 3) {
      final delta = energyNow - energyBefore;
      if (delta >= 0.2) {
        lines.add('This week brightened compared with last.');
      } else if (delta <= -0.2) {
        lines.add('This week was more muted than last.');
      }
    } else if (energyNow != null) {
      if (energyNow >= 0.75) {
        lines.add('You leaned toward vivid, bright shades this week.');
      } else if (energyNow <= 0.35) {
        lines.add('You leaned toward deep, muted shades this week.');
      }
    }

    final families = thisWeek.map((e) => e.family).toSet();
    if (families.length == 1) {
      lines.add('One color family all week — ${families.first} is clearly '
          'carrying something for you.');
    } else if (families.length >= 5) {
      lines.add('A wide range this week — ${families.length} different color '
          'families.');
    }

    if (lines.isEmpty) {
      lines.add('A steady week — no strong shift from your recent pattern.');
    }
    return lines;
  }
}
