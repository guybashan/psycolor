import 'package:psycolor/theme/app_colors.dart';

/// Authentic Lüscher-style functional interpretation.
///
/// In the classic method the eight colors are read not individually but by
/// the *position* they land in. The ranking is split into four functional
/// pairs:
///   positions 1–2  →  the goal / desired direction ("+" function)
///   positions 3–4  →  the present situation (the acting self)
///   positions 5–6  →  restrained qualities (held in reserve)
///   positions 7–8  →  what is rejected / the source of anxiety ("−" function)
///
/// Each color therefore needs two readings: how it speaks when *chosen*
/// (a drive being pursued) and when *rejected* (a need being suppressed).
class ColorFunctions {
  const ColorFunctions({
    required this.desire,
    required this.present,
    required this.restraint,
    required this.rejection,
  });

  /// Reads in positions 1–2 (pursued goal).
  final String desire;

  /// Reads in positions 3–4 (present, operative state).
  final String present;

  /// Reads in positions 5–6 (a quality kept in reserve).
  final String restraint;

  /// Reads in positions 7–8 (suppressed / anxiety-linked need).
  final String rejection;
}

const Map<TestColorId, ColorFunctions> luscherFunctions = {
  TestColorId.blue: ColorFunctions(
    desire:
        'You are seeking calm and a settled, harmonious bond — a place, or a '
        'person, where you can finally let your guard down.',
    present:
        'You are operating from a need for peace and stability, trying to keep '
        'things smooth and untroubled around you.',
    restraint:
        'You are holding your need for rest and closeness in check, carrying '
        'on rather than pausing to be soothed.',
    rejection:
        'Calm feels out of reach right now — stillness may read as emptiness, '
        'and you keep moving to avoid feeling it.',
  ),
  TestColorId.green: ColorFunctions(
    desire:
        'You want to stand firm and be recognized — to hold your ground, '
        'assert your worth, and have your persistence acknowledged.',
    present:
        'You are asserting yourself and defending your position, determined to '
        'control the shape of your own circumstances.',
    restraint:
        'You are keeping your willpower in reserve, not yet pressing the claim '
        'or standing as firmly as you could.',
    rejection:
        'The pressure to hold firm has worn thin — resistance feels costly, '
        'and you would rather not have to prove your standing again.',
  ),
  TestColorId.red: ColorFunctions(
    desire:
        'You are reaching for intensity and momentum — action, desire, the '
        'feeling of life moving fast and fully.',
    present:
        'You are running on drive and appetite, meeting things head-on and '
        'wanting results now rather than later.',
    restraint:
        'You are holding your intensity back, keeping your energy banked '
        'rather than spending it openly.',
    rejection:
        'Your vitality feels depleted — demands that call for energy are '
        'draining, and you are guarding what little charge you have left.',
  ),
  TestColorId.yellow: ColorFunctions(
    desire:
        'You are looking toward possibility and release — hoping for change, '
        'lightness, and an opening into something better.',
    present:
        'You are living in anticipation, orienting toward what is next and '
        'keeping your options hopefully open.',
    restraint:
        'You are keeping your optimism measured, not fully trusting the '
        'brighter possibility yet.',
    rejection:
        'Hope has narrowed — expectations may have been disappointed, and you '
        'are protecting yourself against wanting too much.',
  ),
  TestColorId.violet: ColorFunctions(
    desire:
        'You want a sense of magic and mutual recognition — to feel special, '
        'understood, and identified-with by someone who truly gets you.',
    present:
        'You are seeking to charm and be charmed, wanting your inner world '
        'mirrored back and acknowledged.',
    restraint:
        'You are keeping your longing for enchantment and recognition '
        'private, not fully showing it.',
    rejection:
        'You are pushing away wishful identification, insisting on realism — '
        'perhaps because fantasy once let you down.',
  ),
  TestColorId.brown: ColorFunctions(
    desire:
        'You are craving security and bodily ease — comfort, safety, and a '
        'settled place where your needs are met.',
    present:
        'You are attending to comfort and security, keeping close to what '
        'feels safe and familiar.',
    restraint:
        'You are holding your need for rest and rootedness in check, denying '
        'yourself full comfort for now.',
    rejection:
        'You are suppressing physical needs, driving yourself past comfort — '
        'sometimes a sign of strain being overridden.',
  ),
  TestColorId.black: ColorFunctions(
    desire:
        'You want to refuse and reset on your own terms — to draw a hard line, '
        'reclaim control, and let nothing dictate to you.',
    present:
        'You are in a stance of refusal or protest, resisting circumstances '
        'you feel should not be as they are.',
    restraint:
        'You are holding back the urge to renounce or walk away, tolerating '
        'more than you would like.',
    rejection:
        'You are refusing to give up or give in — you will not renounce what '
        'you want, even under pressure.',
  ),
  TestColorId.gray: ColorFunctions(
    desire:
        'You want to stand apart and stay uninvolved — a buffer of distance '
        'between you and the demands around you.',
    present:
        'You are keeping yourself at a remove, uncommitted and shielded, '
        'watching rather than entering.',
    restraint:
        'You are only partly withdrawn, still involved despite a wish to step '
        'back.',
    rejection:
        'You refuse to be sidelined — you want to participate fully and will '
        'not be shut out or left neutral.',
  ),
};
