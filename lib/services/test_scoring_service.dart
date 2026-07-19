import 'package:psycolor/data/personality_profiles.dart';
import 'package:psycolor/models/test_result.dart';
import 'package:psycolor/services/luscher_reading_service.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

class TestScoringService {
  const TestScoringService();

  static const _luscher = LuscherReadingService();

  TestResult score({
    required List<TestColorId> pass1Order,
    required List<TestColorId> pass2Order,
  }) {
    final primaryColor = pass1Order.first;
    final profile = profileForTopColor(primaryColor);

    // The authentic Lüscher reading: interpret pass 1 (how you feel now) by
    // functional position-pairs — goal, present, reserve, rejection, and the
    // compensation tension between top and bottom.
    final sections = <ProfileSection>[
      ..._luscher.readingFor(pass1Order),
    ];

    // The gap between "how I feel" and "how I want to feel" is the
    // centerpiece of the two-pass design — surface it prominently.
    sections.add(nowVersusWant(pass1Order.first, pass2Order.first));

    for (final color in TestColorId.values) {
      final p1 = pass1Order.indexOf(color) + 1;
      final p2 = pass2Order.indexOf(color) + 1;
      final insight = shiftInsight(color, p1, p2);
      if (insight != null) {
        sections.add(
          ProfileSection(
            title: '${color.name} moved',
            body: insight,
          ),
        );
      }
    }

    if (profile.questions.isNotEmpty) {
      sections.add(
        ProfileSection(
          title: 'Questions to sit with',
          body: profile.questions.map((q) => '•  $q').join('\n\n'),
        ),
      );
    }

    sections.add(
      const ProfileSection(
        title: 'About this reading',
        body:
            'This follows the classic Lüscher color method: your ranking is '
            'read by the position each color lands in, not by taste alone. '
            'It is a mirror for reflection, not a clinical measurement — keep '
            'what rings true, leave what doesn\'t.',
      ),
    );

    final auraColors = pass1Order.take(3).toList();

    return TestResult(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      pass1Order: pass1Order,
      pass2Order: pass2Order,
      profileId: profile.id,
      archetype: _luscher.archetypeFor(pass1Order),
      tagline: _luscher.taglineFor(pass1Order),
      sections: sections,
      auraColors: auraColors,
    );
  }
}
