import 'package:psycolor/models/test_result.dart';
import 'package:psycolor/theme/app_colors.dart';

const _topColorProfiles = {
  TestColorId.blue: PersonalityProfile(
    id: 'quiet_seeker',
    archetype: 'The Quiet Seeker',
    tagline: 'You crave depth, stillness, and meaningful connection.',
    primaryColor: TestColorId.blue,
    sections: [
      ProfileSection(
        title: 'Inner World',
        body:
            'Blue at the top reveals a soul drawn to tranquility. You process life inwardly, '
            'seeking harmony before action. Crowds drain you; quiet spaces restore you.',
      ),
      ProfileSection(
        title: 'Relationships',
        body:
            'You offer loyal, thoughtful presence. Others trust your calm judgment, though you '
            'may need encouragement to voice your needs openly.',
      ),
      ProfileSection(
        title: 'Growth Edge',
        body:
            'Balance your need for peace with gentle assertiveness. Your sensitivity is strength '
            'when paired with clear boundaries.',
      ),
    ],
  ),
  TestColorId.green: PersonalityProfile(
    id: 'steady_force',
    archetype: 'The Steady Force',
    tagline: 'Determined, grounded, and quietly powerful.',
    primaryColor: TestColorId.green,
    sections: [
      ProfileSection(
        title: 'Inner World',
        body:
            'Green leading your choices signals persistence and self-respect. You set goals and '
            'follow through, often becoming the anchor others rely on.',
      ),
      ProfileSection(
        title: 'Relationships',
        body:
            'You show love through reliability and practical support. Partners appreciate your '
            'steadfastness, though spontaneity can enrich your connections.',
      ),
      ProfileSection(
        title: 'Growth Edge',
        body:
            'Allow flexibility alongside discipline. Rest is not weakness—it fuels your '
            'remarkable endurance.',
      ),
    ],
  ),
  TestColorId.red: PersonalityProfile(
    id: 'vital_spark',
    archetype: 'The Vital Spark',
    tagline: 'Passion, energy, and the courage to act.',
    primaryColor: TestColorId.red,
    sections: [
      ProfileSection(
        title: 'Inner World',
        body:
            'Red at the forefront speaks of vitality and drive. You meet life head-on, motivated '
            'by challenge and the thrill of achievement.',
      ),
      ProfileSection(
        title: 'Relationships',
        body:
            'Your enthusiasm is contagious. You love boldly and expect honesty in return. '
            'Patience with slower tempos deepens your bonds.',
      ),
      ProfileSection(
        title: 'Growth Edge',
        body:
            'Channel intensity into focused goals. Pause before reacting—your power grows when '
            'tempered with reflection.',
      ),
    ],
  ),
  TestColorId.yellow: PersonalityProfile(
    id: 'bright_horizon',
    archetype: 'The Bright Horizon',
    tagline: 'Optimism, curiosity, and hope for what comes next.',
    primaryColor: TestColorId.yellow,
    sections: [
      ProfileSection(
        title: 'Inner World',
        body:
            'Yellow leading reveals an expectant mind. You look forward, imagining possibilities '
            'and finding light even in uncertain moments.',
      ),
      ProfileSection(
        title: 'Relationships',
        body:
            'You uplift others with humor and warmth. Friends gravitate to your sunny outlook, '
            'though you benefit from friends who listen when optimism fades.',
      ),
      ProfileSection(
        title: 'Growth Edge',
        body:
            'Ground your hopes in small, daily steps. Joy deepens when paired with realistic planning.',
      ),
    ],
  ),
  TestColorId.violet: PersonalityProfile(
    id: 'noble_dreamer',
    archetype: 'The Noble Dreamer',
    tagline: 'Dignity, imagination, and a strong sense of self.',
    primaryColor: TestColorId.violet,
    sections: [
      ProfileSection(
        title: 'Inner World',
        body:
            'Violet at the top reflects identification and idealism. You hold yourself to high '
            'standards and seek experiences that feel meaningful and authentic.',
      ),
      ProfileSection(
        title: 'Relationships',
        body:
            'You desire deep recognition—not flattery, but being truly seen. You give loyalty '
            'to those who respect your inner world.',
      ),
      ProfileSection(
        title: 'Growth Edge',
        body:
            'Perfection can isolate you. Share imperfect moments—they invite the intimacy you crave.',
      ),
    ],
  ),
  TestColorId.brown: PersonalityProfile(
    id: 'rooted_soul',
    archetype: 'The Rooted Soul',
    tagline: 'Comfort, stability, and appreciation for the tangible.',
    primaryColor: TestColorId.brown,
    sections: [
      ProfileSection(
        title: 'Inner World',
        body:
            'Brown leading shows a need for physical and emotional security. You value routines, '
            'sensory pleasure, and environments that feel safe and warm.',
      ),
      ProfileSection(
        title: 'Relationships',
        body:
            'You express care through presence and practical gestures. Loved ones feel held by '
            'your consistency and grounded affection.',
      ),
      ProfileSection(
        title: 'Growth Edge',
        body:
            'Step occasionally beyond comfort zones. Small adventures expand your sense of safety.',
      ),
    ],
  ),
  TestColorId.black: PersonalityProfile(
    id: 'independent_mind',
    archetype: 'The Independent Mind',
    tagline: 'Self-reliance, boundaries, and quiet strength.',
    primaryColor: TestColorId.black,
    sections: [
      ProfileSection(
        title: 'Inner World',
        body:
            'Black at the forefront signals renunciation—you protect your autonomy and may withdraw '
            'when overwhelmed. Solitude recharges your clarity.',
      ),
      ProfileSection(
        title: 'Relationships',
        body:
            'You connect selectively and deeply. Trust builds slowly, but once given, your loyalty '
            'is unwavering.',
      ),
      ProfileSection(
        title: 'Growth Edge',
        body:
            'Let trusted others in before walls grow too high. Independence thrives alongside '
            'chosen vulnerability.',
      ),
    ],
  ),
  TestColorId.gray: PersonalityProfile(
    id: 'neutral_observer',
    archetype: 'The Neutral Observer',
    tagline: 'Balance, detachment, and thoughtful perspective.',
    primaryColor: TestColorId.gray,
    sections: [
      ProfileSection(
        title: 'Inner World',
        body:
            'Gray leading suggests non-involvement—you prefer to watch, analyze, and decide without '
            'emotional turbulence. You value fairness and objectivity.',
      ),
      ProfileSection(
        title: 'Relationships',
        body:
            'You mediate conflicts well and offer calm advice. Intimacy grows when you share feelings, '
            'not just observations.',
      ),
      ProfileSection(
        title: 'Growth Edge',
        body:
            'Engage with life’s colors more directly. Neutrality is restful, but passion gives it meaning.',
      ),
    ],
  ),
};

const _shiftInsights = {
  TestColorId.red: 'You may be holding back vitality—consider where you can safely express drive.',
  TestColorId.blue: 'A longing for calm suggests your environment may feel overstimulating.',
  TestColorId.yellow: 'Hope is rising—you’re orienting toward brighter possibilities ahead.',
  TestColorId.green: 'You’re seeking more stability and self-assertion in daily life.',
  TestColorId.violet: 'Dignity and self-expression are becoming more important to you.',
  TestColorId.brown: 'Physical comfort and grounding routines are calling for attention.',
  TestColorId.black: 'A need for boundaries and independence is emerging strongly.',
  TestColorId.gray: 'You may be stepping back to gain perspective before committing.',
};

PersonalityProfile profileForTopColor(TestColorId color) =>
    _topColorProfiles[color]!;

String? shiftInsight(TestColorId color, int pass1Rank, int pass2Rank) {
  final shift = pass1Rank - pass2Rank;
  if (shift.abs() < 3) return null;
  return _shiftInsights[color];
}
