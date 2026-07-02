import 'package:hive_flutter/hive_flutter.dart';
import 'package:psycolor/models/credit_package.dart';

class CreditService {
  CreditService(this._box);

  final Box<dynamic> _box;
  static const _balanceKey = 'balance';

  int get balance => (_box.get(_balanceKey) as int?) ?? initialCredits;

  Future<void> initialize() async {
    if (!_box.containsKey(_balanceKey)) {
      await _box.put(_balanceKey, initialCredits);
    }
  }

  Future<bool> deduct(int amount) async {
    if (balance < amount) return false;
    await _box.put(_balanceKey, balance - amount);
    return true;
  }

  Future<void> grant(int amount) async {
    await _box.put(_balanceKey, balance + amount);
  }
}
