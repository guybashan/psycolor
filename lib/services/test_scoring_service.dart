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

    for (final color in TestColorId.values) {
      final p1 = pass1Order.indexOf(color) + 1;
      final p2 = pass2Order.indexOf(color) + 1;
      final insight = shiftInsight(color, p1, p2);
      if (insight != null) {
        sections.add(
          ProfileSection(
            title: '${color.name} Shift',
            body: insight,
          ),
        );
      }
    }

    final rejected = pass1Order.last;
    if (rejected == TestColorId.gray || rejected == TestColorId.black) {
      sections.add(
        ProfileSection(
          title: 'Hidden Tension',
          body:
              'Placing ${rejected.name} last suggests you may be distancing yourself from '
              '${rejected.trait.toLowerCase()}. Notice if this protects or limits you.',
        ),
      );
    }

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
