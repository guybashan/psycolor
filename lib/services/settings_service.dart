import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  SettingsService(this._box);

  final Box<dynamic> _box;
  static const _onboardingKey = 'hasSeenOnboarding';

  bool get hasSeenOnboarding =>
      (_box.get(_onboardingKey) as bool?) ?? false;

  Future<void> setHasSeenOnboarding(bool value) async {
    await _box.put(_onboardingKey, value);
  }
}
