import 'package:psycolor/data/personality_profiles.dart';
import 'package:psycolor/models/test_result.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

class TestScoringService {
  const TestScoringService();

  TestResult score({
    required List<TestColorId> pass1Order,
    required List<TestColorId> pass2Order,
  }) {
    final primaryColor = pass1Order.first;
    final profile = profileForTopColor(primaryColor);

    final sections = List<ProfileSection>.from(profile.sections);

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

    final rejected = pass1Order.last;
    if (rejected == TestColorId.gray || rejected == TestColorId.black) {
      sections.add(
        ProfileSection(
          title: 'What you pushed away',
          body:
              'You placed ${rejected.name} last. People often push a color to '
              'the bottom when what it stands for — ${rejected.trait.toLowerCase()} — '
              'feels unwanted or unsafe right now. Worth a look: is that '
              'distance protecting you, or costing you?',
        ),
      );
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
            'This exercise follows the classic color-ranking tradition. It is '
            'a mirror for self-reflection, not a measurement or diagnosis — '
            'keep what rings true, leave what doesn\'t.',
      ),
    );

    final auraColors = pass1Order.take(3).toList();

    return TestResult(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      pass1Order: pass1Order,
      pass2Order: pass2Order,
      profileId: profile.id,
      archetype: profile.archetype,
      tagline: profile.tagline,
      sections: sections,
      auraColors: auraColors,
    );
  }
}
