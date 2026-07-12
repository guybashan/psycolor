import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:psycolor/models/mood_entry.dart';
import 'package:psycolor/services/mood_service.dart';

MoodEntry entry(DateTime day, {String family = 'blue', String tone = 'soft'}) {
  return MoodEntry(
    dateKey: MoodEntry.dateKeyFor(day),
    family: family,
    tone: tone,
    colorValue: 0xFF000000,
    createdAt: day,
  );
}

void main() {
  late Box<dynamic> box;
  late MoodService service;
  final today = DateTime(2026, 7, 10);

  setUpAll(() async {
    Hive.init('./test_hive');
  });

  setUp(() async {
    box = await Hive.openBox('mood_test_${DateTime.now().microsecondsSinceEpoch}');
    service = MoodService(box);
  });

  tearDown(() async {
    await box.deleteFromDisk();
  });

  group('palette', () {
    test('has 27 distinct swatches (9 families x 3 tones)', () {
      final palette = service.palette();
      expect(palette.length, 27);
      final colors = palette.map((s) => s.color.toARGB32()).toSet();
      expect(colors.length, 27, reason: 'all swatches must be distinct');
    });

    test('families and tones are well-formed', () {
      final palette = service.palette();
      final families = palette.map((s) => s.family).toSet();
      expect(families.length, 9);
      expect(families, contains('neutral'));
      for (final s in palette) {
        expect(['bright', 'soft', 'deep'], contains(s.tone));
      }
    });
  });

  group('persistence', () {
    test('one entry per day: same-day save replaces', () async {
      await service.save(entry(today, family: 'red'));
      await service.save(entry(today, family: 'blue'));
      final all = service.getAll();
      expect(all.length, 1);
      expect(all.first.family, 'blue');
    });
  });

  group('streak', () {
    test('counts consecutive days ending today', () {
      final entries = [
        entry(today),
        entry(today.subtract(const Duration(days: 1))),
        entry(today.subtract(const Duration(days: 2))),
        // gap
        entry(today.subtract(const Duration(days: 5))),
      ];
      expect(service.streak(entries, today), 3);
    });

    test('yesterday-ending streak still counts (today not logged yet)', () {
      final entries = [
        entry(today.subtract(const Duration(days: 1))),
        entry(today.subtract(const Duration(days: 2))),
      ];
      expect(service.streak(entries, today), 2);
    });

    test('no recent entries means zero', () {
      final entries = [entry(today.subtract(const Duration(days: 3)))];
      expect(service.streak(entries, today), 0);
    });
  });

  group('trend lines', () {
    test('needs at least 3 entries this week', () {
      final lines = service.trendLines([entry(today)], today);
      expect(lines.single, contains('few more days'));
    });

    test('detects warming vs last week', () {
      final entries = [
        // this week: warm
        entry(today, family: 'red'),
        entry(today.subtract(const Duration(days: 1)), family: 'orange'),
        entry(today.subtract(const Duration(days: 2)), family: 'yellow'),
        // last week: cool
        entry(today.subtract(const Duration(days: 7)), family: 'blue'),
        entry(today.subtract(const Duration(days: 8)), family: 'teal'),
        entry(today.subtract(const Duration(days: 9)), family: 'blue'),
      ];
      final lines = service.trendLines(entries, today);
      expect(lines.any((l) => l.contains('warmer')), isTrue);
    });

    test('detects brightening vs last week', () {
      final entries = [
        entry(today, tone: 'bright'),
        entry(today.subtract(const Duration(days: 1)), tone: 'bright'),
        entry(today.subtract(const Duration(days: 2)), tone: 'bright'),
        entry(today.subtract(const Duration(days: 7)), tone: 'deep'),
        entry(today.subtract(const Duration(days: 8)), tone: 'deep'),
        entry(today.subtract(const Duration(days: 9)), tone: 'deep'),
      ];
      final lines = service.trendLines(entries, today);
      expect(lines.any((l) => l.contains('brightened')), isTrue);
    });

    test('single-family week is called out', () {
      final entries = [
        entry(today, family: 'neutral'),
        entry(today.subtract(const Duration(days: 1)), family: 'neutral'),
        entry(today.subtract(const Duration(days: 2)), family: 'neutral'),
      ];
      final lines = service.trendLines(entries, today);
      expect(lines.any((l) => l.contains('One color family')), isTrue);
    });

    test('steady week falls back to neutral statement', () {
      final entries = [
        entry(today, family: 'blue', tone: 'soft'),
        entry(today.subtract(const Duration(days: 1)), family: 'red', tone: 'soft'),
        entry(today.subtract(const Duration(days: 2)), family: 'green', tone: 'soft'),
        entry(today.subtract(const Duration(days: 3)), family: 'violet', tone: 'soft'),
        entry(today.subtract(const Duration(days: 7)), family: 'blue', tone: 'soft'),
        entry(today.subtract(const Duration(days: 8)), family: 'red', tone: 'soft'),
        entry(today.subtract(const Duration(days: 9)), family: 'green', tone: 'soft'),
      ];
      final lines = service.trendLines(entries, today);
      expect(lines, isNotEmpty);
    });
  });
}
