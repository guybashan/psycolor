import 'package:flutter_test/flutter_test.dart';
import 'package:psycolor/services/test_scoring_service.dart';
import 'package:psycolor/theme/app_colors.dart';

void main() {
  const scorer = TestScoringService();

  test('scores result with archetype from top pass1 color', () {
    final pass1 = List<TestColorId>.from(defaultColorOrder);
    final pass2 = List<TestColorId>.from(defaultColorOrder.reversed);

    final result = scorer.score(pass1Order: pass1, pass2Order: pass2);

    expect(result.archetype, isNotEmpty);
    expect(result.sections, isNotEmpty);
    expect(result.auraColors.length, 3);
    expect(result.pass1Order.first, TestColorId.blue);
  });
}
