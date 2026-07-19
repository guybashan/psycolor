import 'package:psycolor/data/luscher_meanings.dart';
import 'package:psycolor/models/test_result.dart';
import 'package:psycolor/theme/app_colors.dart';

/// Builds the authentic Lüscher functional reading from a full 8-color
/// ranking (most-preferred first). Reads by position-pair rather than by the
/// single top color, which is what gives the classic method its specificity.
class LuscherReadingService {
  const LuscherReadingService();

  /// Ordered functional sections for a single pass's ranking.
  List<ProfileSection> readingFor(List<TestColorId> order) {
    assert(order.length == 8);
    final desired = order[0];
    final present = order[2];
    final restrained = order[4];
    final rejected = order[7];

    final sections = <ProfileSection>[
      ProfileSection(
        title: 'Your goal — where you\'re headed',
        body: luscherFunctions[desired]!.desire,
      ),
      ProfileSection(
        title: 'The present — how you\'re acting now',
        body: luscherFunctions[present]!.present,
      ),
      ProfileSection(
        title: 'Held in reserve',
        body: luscherFunctions[restrained]!.restraint,
      ),
      ProfileSection(
        title: 'What you\'re pushing away',
        body: luscherFunctions[rejected]!.rejection,
      ),
    ];

    final conflict = _conflictSection(order);
    if (conflict != null) sections.add(conflict);

    return sections;
  }

  /// The signature Lüscher insight: a color rejected to the bottom two
  /// positions signals a real need under suppression, which the mind
  /// compensates for through whatever sits at the very top. Naming that
  /// compensation is the reading's most striking moment.
  ProfileSection? _conflictSection(List<TestColorId> order) {
    final rejected = order[7];
    final top = order[0];
    if (rejected == top) return null;

    return ProfileSection(
      title: 'The tension underneath',
      body:
          'Placing ${rejected.name} last while leading with ${top.name} is the '
          'reading\'s most telling pattern. A need tied to '
          '${rejected.trait.toLowerCase()} appears to be under strain, and '
          'you may be compensating for it through '
          '${top.trait.toLowerCase()}. Worth asking: is the thing at the top '
          'what you truly want, or what you\'re reaching for because the '
          'thing at the bottom feels out of reach?',
    );
  }

  /// A short label for the state implied by the top-two "goal" pair, used as
  /// the result's archetype line.
  String archetypeFor(List<TestColorId> order) {
    return _archetypes[order[0]]!;
  }

  String taglineFor(List<TestColorId> order) {
    return luscherFunctions[order[0]]!.desire;
  }

  static const Map<TestColorId, String> _archetypes = {
    TestColorId.blue: 'Seeking Stillness',
    TestColorId.green: 'Holding Ground',
    TestColorId.red: 'Chasing Intensity',
    TestColorId.yellow: 'Reaching for Light',
    TestColorId.violet: 'Longing to Be Seen',
    TestColorId.brown: 'Wanting Safety',
    TestColorId.black: 'Drawing the Line',
    TestColorId.gray: 'Keeping Distance',
  };
}
