import 'package:psycolor/models/test_result.dart';
import 'package:psycolor/theme/app_colors.dart';

/// Written as a mirror, not a verdict: every profile describes what people
/// who choose this way often report, then hands the question back to the
/// reader. Nothing here claims to measure — it invites reflection.
const _topColorProfiles = {
  TestColorId.blue: PersonalityProfile(
    id: 'quiet_seeker',
    archetype: 'The Quiet Seeker',
    tagline: 'Right now, stillness may matter more to you than stimulation.',
    primaryColor: TestColorId.blue,
    sections: [
      ProfileSection(
        title: 'What this choice often accompanies',
        body:
            'People who reach for blue first often describe a pull toward calm — '
            'a wish for fewer demands, softer inputs, more room to breathe. '
            'Sometimes it comes after a loud stretch of life; sometimes it is '
            'simply how they are built. Notice which one feels closer today.',
      ),
      ProfileSection(
        title: 'Around other people',
        body:
            'If calm is what you are seeking, company can feel like a trade-off: '
            'connection is nourishing, but it costs quiet. Many blue-first '
            'choosers say they are generous listeners who rarely ask to be '
            'listened to. If that rings true, it is worth asking what you are '
            'not saying, and to whom you could say it.',
      ),
      ProfileSection(
        title: 'A gentle push',
        body:
            'Peace protected too fiercely can shade into avoidance. One honest '
            'conversation, one clear request — small acts of assertion tend to '
            'make the calm you value feel earned rather than defended.',
      ),
    ],
    questions: [
      'What in your week is loudest right now — and is it noise you chose?',
      'When did you last feel genuinely rested, not just paused?',
      'What would you ask for, if asking cost nothing?',
    ],
  ),
  TestColorId.green: PersonalityProfile(
    id: 'steady_force',
    archetype: 'The Steady Force',
    tagline: 'Holding your ground may be the theme of this moment.',
    primaryColor: TestColorId.green,
    sections: [
      ProfileSection(
        title: 'What this choice often accompanies',
        body:
            'Green placed first often shows up in people who are mid-effort: '
            'building something, defending a standard, refusing to be moved. '
            'It can feel like strength from the inside and stubbornness from '
            'the outside. Both readings are usually a little true.',
      ),
      ProfileSection(
        title: 'Around other people',
        body:
            'Reliability is likely your love language — showing up, following '
            'through. The quiet risk is that consistency gets taken as granted, '
            'or that you keep score silently. If someone owes you recognition, '
            'they probably do not know it.',
      ),
      ProfileSection(
        title: 'A gentle push',
        body:
            'Endurance is a resource, not an identity. Ask yourself which of '
            'your current commitments still deserves your persistence — and '
            'which one you are holding simply because letting go feels like '
            'losing.',
      ),
    ],
    questions: [
      'What are you currently proving, and to whom?',
      'Where does your persistence serve you — and where does it just cost you?',
      'What would you do with a week nobody needed you?',
    ],
  ),
  TestColorId.red: PersonalityProfile(
    id: 'vital_spark',
    archetype: 'The Vital Spark',
    tagline: 'Appetite for action seems close to the surface right now.',
    primaryColor: TestColorId.red,
    sections: [
      ProfileSection(
        title: 'What this choice often accompanies',
        body:
            'Red first usually belongs to a season of wanting — more intensity, '
            'more progress, more life per hour. It can mean you are energized, '
            'or that you are impatient with how slowly things are moving. '
            'The difference matters: one fills you, the other burns you.',
      ),
      ProfileSection(
        title: 'Around other people',
        body:
            'Your pace sets the room\'s pace, whether you intend it or not. '
            'People likely borrow energy from you — and some may struggle to '
            'tell you when the tempo is too much. Who around you has gone '
            'quiet lately?',
      ),
      ProfileSection(
        title: 'A gentle push',
        body:
            'Drive obeys direction. If everything feels urgent, nothing is. '
            'Choosing one target this week — and letting the rest genuinely '
            'wait — is the harder, stronger move.',
      ),
    ],
    questions: [
      'What are you racing toward — and what are you racing from?',
      'Which fire is worth your fuel this month?',
      'When you slow down, what feeling shows up first?',
    ],
  ),
  TestColorId.yellow: PersonalityProfile(
    id: 'bright_horizon',
    archetype: 'The Bright Horizon',
    tagline: 'You seem oriented toward what comes next.',
    primaryColor: TestColorId.yellow,
    sections: [
      ProfileSection(
        title: 'What this choice often accompanies',
        body:
            'Yellow first often marks a forward lean — anticipation, plans, '
            'the sense that something better is approaching or ought to be. '
            'It can be genuine hope, and it can be escape dressed as hope: '
            'tomorrow as a more comfortable place to live than today.',
      ),
      ProfileSection(
        title: 'Around other people',
        body:
            'You likely raise the temperature of a room — people leave '
            'conversations with you lighter than they arrived. The trade is '
            'that your heavier moments may go unseen, because nobody expects '
            'them from you. Who is allowed to see you un-sunny?',
      ),
      ProfileSection(
        title: 'A gentle push',
        body:
            'Hope becomes real through small, scheduled steps. Pick one thing '
            'you keep imagining and give it fifteen concrete minutes today — '
            'anticipation converts to satisfaction only through action.',
      ),
    ],
    questions: [
      'What are you looking forward to — specifically, not vaguely?',
      'Is your optimism fed by plans, or replacing them?',
      'What in the present deserves more of your attention than the future is getting?',
    ],
  ),
  TestColorId.violet: PersonalityProfile(
    id: 'noble_dreamer',
    archetype: 'The Noble Dreamer',
    tagline: 'Being truly seen may matter more than usual right now.',
    primaryColor: TestColorId.violet,
    sections: [
      ProfileSection(
        title: 'What this choice often accompanies',
        body:
            'Violet first often appears when identity is active: questions of '
            'who you are, what you stand for, whether your outer life matches '
            'your inner one. People in this spot describe wanting experiences '
            'that feel meaningful — and feeling faintly starved by ones that don\'t.',
      ),
      ProfileSection(
        title: 'Around other people',
        body:
            'You may notice a hunger not for praise but for recognition — the '
            'difference between "well done" and "I see what this cost you." '
            'Few people give that unprompted. The ones who do are worth telling.',
      ),
      ProfileSection(
        title: 'A gentle push',
        body:
            'High standards can quietly become a wall: nothing imperfect goes '
            'out, so nothing intimate gets in. Sharing something unfinished — '
            'a draft, a doubt — is often the fastest route to the closeness '
            'you are actually after.',
      ),
    ],
    questions: [
      'Where does your outer life least match your inner one?',
      'Whose recognition would actually land — and have you let them close enough to give it?',
      'What imperfect thing could you show someone this week?',
    ],
  ),
  TestColorId.brown: PersonalityProfile(
    id: 'rooted_soul',
    archetype: 'The Rooted Soul',
    tagline: 'Comfort and safety seem to be asking for attention.',
    primaryColor: TestColorId.brown,
    sections: [
      ProfileSection(
        title: 'What this choice often accompanies',
        body:
            'Brown placed first often signals that the body is speaking: a wish '
            'for rest, warmth, good food, familiar places. Sometimes it follows '
            'a stretch of strain. It is worth taking literally before taking '
            'symbolically — are you tired, under-slept, running on habit?',
      ),
      ProfileSection(
        title: 'Around other people',
        body:
            'You likely care through presence — being there, making things '
            'comfortable, remembering the practical details. That steadiness '
            'is felt more than it is mentioned. It is also worth receiving: '
            'who comforts the comforter?',
      ),
      ProfileSection(
        title: 'A gentle push',
        body:
            'Security grows strangely: a little novelty strengthens it, total '
            'safety shrinks it. One small unfamiliar thing — a route, a dish, '
            'a conversation — keeps comfort from becoming confinement.',
      ),
    ],
    questions: [
      'What is your body asking for that your schedule keeps refusing?',
      'Which comfort in your life restores you — and which one just numbs?',
      'What tiny adventure feels almost, but not quite, safe?',
    ],
  ),
  TestColorId.black: PersonalityProfile(
    id: 'independent_mind',
    archetype: 'The Independent Mind',
    tagline: 'Boundaries may be doing important work for you right now.',
    primaryColor: TestColorId.black,
    sections: [
      ProfileSection(
        title: 'What this choice often accompanies',
        body:
            'Black first often shows up when someone is protecting something — '
            'time, energy, a decision, a self. It can mean strong healthy '
            'boundaries; it can also mean a drawbridge pulled up after '
            'disappointment. Only you know which castle this is.',
      ),
      ProfileSection(
        title: 'Around other people',
        body:
            'You probably connect selectively, and the few who are in are '
            'genuinely in. The cost of high walls is that people stop knocking. '
            'If solitude has started to feel less like a choice and more like '
            'a default, that is information.',
      ),
      ProfileSection(
        title: 'A gentle push',
        body:
            'Independence is strongest when it can afford exceptions. Letting '
            'one trusted person see one guarded thing — that is not a breach '
            'of your autonomy; it is proof of it.',
      ),
    ],
    questions: [
      'What are you protecting right now — and from whom?',
      'Which of your walls still serves you, and which one outlived its reason?',
      'Who has earned more access than you have given them?',
    ],
  ),
  TestColorId.gray: PersonalityProfile(
    id: 'neutral_observer',
    archetype: 'The Neutral Observer',
    tagline: 'You may be watching your life from a slight distance right now.',
    primaryColor: TestColorId.gray,
    sections: [
      ProfileSection(
        title: 'What this choice often accompanies',
        body:
            'Gray first often marks a step back — observing rather than '
            'entering, weighing rather than committing. Sometimes that is '
            'wisdom: the situation genuinely needs a cool head. Sometimes it '
            'is fatigue wearing wisdom\'s clothes.',
      ),
      ProfileSection(
        title: 'Around other people',
        body:
            'You are likely the level one — the mediator, the fair witness. '
            'People trust your judgment precisely because you keep yourself '
            'out of it. The quiet cost: they may know your opinions better '
            'than your feelings.',
      ),
      ProfileSection(
        title: 'A gentle push',
        body:
            'Neutrality is a fine place to decide from and a poor place to '
            'live. Pick one thing this week to be openly, unreasonably '
            'enthusiastic about — and let someone witness it.',
      ),
    ],
    questions: [
      'What are you currently undecided about — and is the deciding overdue?',
      'When did you last let something matter to you out loud?',
      'What would re-entering your own life look like this week?',
    ],
  ),
};

/// One-line "state" descriptions used to articulate the gap between the
/// color chosen under "how do you feel now" and "how do you want to feel".
const _nowState = {
  TestColorId.red: 'running hot, hungry for action',
  TestColorId.blue: 'seeking quiet and recovery',
  TestColorId.yellow: 'leaning into anticipation',
  TestColorId.green: 'holding ground, mid-effort',
  TestColorId.violet: 'tuned to meaning and identity',
  TestColorId.brown: 'listening to the body\'s need for comfort',
  TestColorId.black: 'guarding your borders',
  TestColorId.gray: 'observing from a distance',
};

const _wantState = {
  TestColorId.red: 'more vitality and momentum',
  TestColorId.blue: 'more calm and space',
  TestColorId.yellow: 'more lightness and possibility',
  TestColorId.green: 'more stability and standing',
  TestColorId.violet: 'more meaning and recognition',
  TestColorId.brown: 'more comfort and groundedness',
  TestColorId.black: 'firmer boundaries and autonomy',
  TestColorId.gray: 'more distance and neutrality',
};

const _shiftInsights = {
  TestColorId.red:
      'Red moved sharply between your two passes — energy you feel and energy '
      'you want are out of step. Where in your life is drive waiting for permission?',
  TestColorId.blue:
      'Blue shifted strongly — your need for calm and your access to it seem '
      'to disagree. What is the loudest thing you could turn down?',
  TestColorId.yellow:
      'Yellow moved a long way between passes — hope is either arriving or '
      'being rationed. Which is it?',
  TestColorId.green:
      'Green shifted notably — questions of standing your ground are in '
      'motion. What position are you deciding whether to hold?',
  TestColorId.violet:
      'Violet traveled between your passes — how much meaning your days carry '
      'may be under quiet renegotiation.',
  TestColorId.brown:
      'Brown moved sharply — your relationship with comfort is changing. '
      'Are you granting yourself rest, or bargaining over it?',
  TestColorId.black:
      'Black shifted strongly between passes — boundaries are being redrawn '
      'somewhere. By you, or for you?',
  TestColorId.gray:
      'Gray moved notably — your distance from things is changing. Stepping '
      'in, or stepping out?',
};

PersonalityProfile profileForTopColor(TestColorId color) =>
    _topColorProfiles[color]!;

String? shiftInsight(TestColorId color, int pass1Rank, int pass2Rank) {
  final shift = pass1Rank - pass2Rank;
  if (shift.abs() < 3) return null;
  return _shiftInsights[color];
}

/// The gap (or alignment) between the top color of each pass — the most
/// telling signal the two-pass design produces.
ProfileSection nowVersusWant(TestColorId now, TestColorId want) {
  if (now == want) {
    return ProfileSection(
      title: 'Now and want: aligned',
      body:
          'You led with ${now.name} in both passes — how you feel and how you '
          'want to feel currently point the same way (${_nowState[now]}). '
          'Alignment like this is usually either contentment or momentum. '
          'Enjoy it, and notice what is sustaining it.',
    );
  }
  return ProfileSection(
    title: 'Now versus want',
    body:
        'Asked how you feel, you led with ${now.name} — ${_nowState[now]}. '
        'Asked how you want to feel, you chose ${want.name} — a reach for '
        '${_wantState[want]}. The distance between those two answers is the '
        'most useful thing this exercise surfaces. What is one small, concrete '
        'step from the first state toward the second you could take today?',
  );
}
