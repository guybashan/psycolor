import 'package:hive_flutter/hive_flutter.dart';
import 'package:psycolor/models/hue_test_result.dart';

class HueHistoryService {
  HueHistoryService(this._box);

  final Box<dynamic> _box;
  static const _historyKey = 'entries';

  List<HueTestResult> getAll() {
    final raw = _box.get(_historyKey) as List<dynamic>?;
    if (raw == null) return [];
    return raw
        .map((e) =>
            HueTestResult.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> save(HueTestResult result) async {
    final entries = getAll().map((r) => r.toMap()).toList();
    entries.insert(0, result.toMap());
    await _box.put(_historyKey, entries);
  }
}
