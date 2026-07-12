import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psycolor/models/mood_entry.dart';
import 'package:psycolor/services/mood_service.dart';

final moodServiceProvider = Provider<MoodService>((ref) {
  return MoodService(Hive.box('mood_history'));
});

final moodEntriesProvider =
    StateNotifierProvider<MoodEntriesNotifier, List<MoodEntry>>((ref) {
  return MoodEntriesNotifier(ref.watch(moodServiceProvider));
});

class MoodEntriesNotifier extends StateNotifier<List<MoodEntry>> {
  MoodEntriesNotifier(this._service) : super(_service.getAll());

  final MoodService _service;

  Future<void> checkIn(MoodSwatch swatch) async {
    final now = DateTime.now();
    await _service.save(MoodEntry(
      dateKey: MoodEntry.dateKeyFor(now),
      family: swatch.family,
      tone: swatch.tone,
      colorValue: swatch.color.toARGB32(),
      createdAt: now,
    ));
    state = _service.getAll();
  }
}

/// Today's entry, if the user already checked in.
final todayMoodProvider = Provider<MoodEntry?>((ref) {
  final entries = ref.watch(moodEntriesProvider);
  final todayKey = MoodEntry.dateKeyFor(DateTime.now());
  for (final e in entries) {
    if (e.dateKey == todayKey) return e;
  }
  return null;
});
