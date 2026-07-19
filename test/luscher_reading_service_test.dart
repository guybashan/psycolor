import 'package:flutter_test/flutter_test.dart';
import 'package:psycolor/services/luscher_reading_service.dart';
import 'package:psycolor/services/test_scoring_service.dart';
import 'package:psycolor/theme/app_colors.dart';

void main() {
  const reading = LuscherReadingService();

  final order = [
    TestColorId.red, // 1 goal
    TestColorId.yellow, // 2 goal
    TestColorId.green, // 3 present
    TestColorId.violet, // 4 present
    TestColorId.brown, // 5 reserve
    TestColorId.black, // 6 reserve
    TestColorId.gray, // 7 rejection
    TestColorId.blue, // 8 rejection (last)
  ];

  group('functional reading', () {
    test('produces goal / present / reserve / rejection + tension', () {
      final sections = reading.readingFor(order);
      final titles = sections.map((s) => s.title).toList();
      expect(titles, contains('Your goal — where you\'re headed'));
      expect(titles, contains('The present — how you\'re acting now'));
      expect(titles, contains('Held in reserve'));
      expect(titles, contains('What you\'re pushing away'));
      expect(titles, contains('The tension underneath'));
    });

    test('goal section is driven by the first color', () {
      final sections = reading.readingFor(order);
      // Red's desire text mentions intensity/momentum.
      expect(sections.first.body.toLowerCase(),
          anyOf(contains('intensity'), contains('momentum')));
    });

    test('rejection section is driven by the last color', () {
      final sections = reading.readingFor(order);
      final rejection =
          sections.firstWhere((s) => s.title == 'What you\'re pushing away');
      // Blue last → calm feeling out of reach.
      expect(rejection.body.toLowerCase(), contains('calm'));
    });

    test('tension section names both top and bottom colors', () {
      final sections = reading.readingFor(order);
      final tension =
          sections.firstWhere((s) => s.title == 'The tension underneath');
      expect(tension.body, contains('Red'));
      expect(tension.body, contains('Blue'));
    });

    test('no tension section when the same color is both first and last '
        '(impossible in practice, guards against bad input)', () {
      final same = List.filled(8, TestColorId.red);
      final sections = reading.readingFor(same);
      expect(sections.any((s) => s.title == 'The tension underneath'), isFalse);
    });

    test('archetype and tagline come from the top color', () {
      expect(reading.archetypeFor(order), 'Chasing Intensity');
      expect(reading.taglineFor(order), isNotEmpty);
    });
  });

  group('full scoring integration', () {
    test('score() yields a Lüscher reading with the tension insight', () {
      const service = TestScoringService();
      final result = service.score(
        pass1Order: order,
        pass2Order: [
          TestColorId.blue,
          TestColorId.green,
          TestColorId.red,
          TestColorId.yellow,
          TestColorId.violet,
          TestColorId.brown,
          TestColorId.black,
          TestColorId.gray,
        ],
      );
      expect(result.archetype, 'Chasing Intensity');
      final titles = result.sections.map((s) => s.title);
      expect(titles, contains('Your goal — where you\'re headed'));
      expect(titles, contains('The tension underneath'));
      expect(titles, contains('Now versus want'));
    });
  });
}
