import 'package:hive_flutter/hive_flutter.dart';
import 'package:psycolor/models/test_result.dart';

class HistoryService {
  HistoryService(this._box);

  final Box<dynamic> _box;
  static const _historyKey = 'entries';

  List<TestResult> getAll() {
    final raw = _box.get(_historyKey) as List<dynamic>?;
    if (raw == null) return [];
    return raw
        .map((e) => TestResult.fromMap(Map<dynamic, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> save(TestResult result) async {
    final entries = getAll().map((r) => r.toMap()).toList();
    entries.insert(0, result.toMap());
    await _box.put(_historyKey, entries);
  }
}
