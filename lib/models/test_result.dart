import 'package:psycolor/theme/app_colors.dart';

class PersonalityProfile {
  const PersonalityProfile({
    required this.id,
    required this.archetype,
    required this.tagline,
    required this.sections,
    required this.primaryColor,
    this.questions = const [],
  });

  final String id;
  final String archetype;
  final String tagline;
  final List<ProfileSection> sections;
  final TestColorId primaryColor;

  /// Reflective prompts handed to the reader at the end of the reading.
  final List<String> questions;
}

class ProfileSection {
  const ProfileSection({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}

class TestResult {
  TestResult({
    required this.id,
    required this.createdAt,
    required this.pass1Order,
    required this.pass2Order,
    required this.profileId,
    required this.archetype,
    required this.tagline,
    required this.sections,
    required this.auraColors,
  });

  final String id;
  final DateTime createdAt;
  final List<TestColorId> pass1Order;
  final List<TestColorId> pass2Order;
  final String profileId;
  final String archetype;
  final String tagline;
  final List<ProfileSection> sections;
  final List<TestColorId> auraColors;

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'pass1Order': pass1Order.map((c) => c.storageKey).toList(),
        'pass2Order': pass2Order.map((c) => c.storageKey).toList(),
        'profileId': profileId,
        'archetype': archetype,
        'tagline': tagline,
        'sections': sections
            .map((s) => {'title': s.title, 'body': s.body})
            .toList(),
        'auraColors': auraColors.map((c) => c.storageKey).toList(),
      };

  factory TestResult.fromMap(Map<dynamic, dynamic> map) {
    return TestResult(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      pass1Order: (map['pass1Order'] as List)
          .map((k) => testColorFromKey(k as String))
          .toList(),
      pass2Order: (map['pass2Order'] as List)
          .map((k) => testColorFromKey(k as String))
          .toList(),
      profileId: map['profileId'] as String,
      archetype: map['archetype'] as String,
      tagline: map['tagline'] as String,
      sections: (map['sections'] as List)
          .map(
            (s) => ProfileSection(
              title: (s as Map)['title'] as String,
              body: s['body'] as String,
            ),
          )
          .toList(),
      auraColors: (map['auraColors'] as List)
          .map((k) => testColorFromKey(k as String))
          .toList(),
    );
  }

  String get shareText {
    final buffer = StringBuffer()
      ..writeln('My PsyColor profile: $archetype')
      ..writeln(tagline)
      ..writeln();
    for (final section in sections) {
      buffer
        ..writeln('${section.title}:')
        ..writeln(section.body)
        ..writeln();
    }
    buffer.writeln('Discover yours with PsyColor');
    return buffer.toString();
  }
}
