import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psycolor/models/credit_package.dart';
import 'package:psycolor/models/test_result.dart';
import 'package:psycolor/services/credit_service.dart';
import 'package:psycolor/services/history_service.dart';
import 'package:psycolor/services/mock_purchase_service.dart';
import 'package:psycolor/services/purchase_service.dart';
import 'package:psycolor/services/settings_service.dart';
import 'package:psycolor/services/test_scoring_service.dart';
import 'package:psycolor/theme/app_colors.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final creditServiceProvider = Provider<CreditService>((ref) {
  return CreditService(Hive.box('credits'));
});

final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService(Hive.box('history'));
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(Hive.box('settings'));
});

final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final key = ref.watch(navigatorKeyProvider);
  return MockPurchaseService(key);
});

final testScoringServiceProvider = Provider<TestScoringService>(
  (ref) => const TestScoringService(),
);

final creditBalanceProvider =
    StateNotifierProvider<CreditNotifier, int>((ref) {
  return CreditNotifier(ref.watch(creditServiceProvider));
});

class CreditNotifier extends StateNotifier<int> {
  CreditNotifier(this._service) : super(_service.balance);

  final CreditService _service;

  void refresh() => state = _service.balance;

  Future<bool> deductForTest() async {
    final ok = await _service.deduct(testCreditCost);
    if (ok) refresh();
    return ok;
  }

  Future<void> grant(int amount) async {
    await _service.grant(amount);
    refresh();
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<TestResult>>((ref) {
  return HistoryNotifier(ref.watch(historyServiceProvider));
});

class HistoryNotifier extends StateNotifier<List<TestResult>> {
  HistoryNotifier(this._service) : super(_service.getAll());

  final HistoryService _service;

  Future<void> add(TestResult result) async {
    await _service.save(result);
    state = _service.getAll();
  }

  void refresh() => state = _service.getAll();
}

final testSessionProvider =
    StateNotifierProvider<TestSessionNotifier, TestSessionState>((ref) {
  return TestSessionNotifier();
});

class TestSessionState {
  TestSessionState({
    this.pass = 1,
    List<TestColorId>? currentOrder,
    this.pass1Order,
    this.pass2Order,
    this.result,
    this.creditReserved = false,
  }) : currentOrder = currentOrder ?? shuffledColorOrder();

  final int pass;
  final List<TestColorId> currentOrder;
  final List<TestColorId>? pass1Order;
  final List<TestColorId>? pass2Order;
  final TestResult? result;
  final bool creditReserved;

  TestSessionState copyWith({
    int? pass,
    List<TestColorId>? currentOrder,
    List<TestColorId>? pass1Order,
    List<TestColorId>? pass2Order,
    TestResult? result,
    bool? creditReserved,
  }) {
    return TestSessionState(
      pass: pass ?? this.pass,
      currentOrder: currentOrder ?? this.currentOrder,
      pass1Order: pass1Order ?? this.pass1Order,
      pass2Order: pass2Order ?? this.pass2Order,
      result: result ?? this.result,
      creditReserved: creditReserved ?? this.creditReserved,
    );
  }
}

class TestSessionNotifier extends StateNotifier<TestSessionState> {
  TestSessionNotifier() : super(TestSessionState());

  void reset() {
    state = TestSessionState();
  }

  void markCreditReserved() {
    state = state.copyWith(creditReserved: true);
  }

  void reorder(int oldIndex, int newIndex) {
    final order = List<TestColorId>.from(state.currentOrder);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = order.removeAt(oldIndex);
    order.insert(newIndex, item);
    state = state.copyWith(currentOrder: order);
  }

  void moveUp(int index) {
    if (index <= 0) return;
    reorder(index, index - 1);
  }

  void moveDown(int index) {
    if (index >= state.currentOrder.length - 1) return;
    reorder(index, index + 1);
  }

  bool completePass() {
    if (state.pass == 1) {
      state = state.copyWith(
        pass1Order: List.from(state.currentOrder),
        pass: 2,
        currentOrder: shuffledColorOrder(),
      );
      return false;
    }

    state = state.copyWith(
      pass2Order: List.from(state.currentOrder),
    );
    return true;
  }

  void setResult(TestResult result) {
    state = state.copyWith(result: result);
  }
}

final purchaseLoadingProvider = StateProvider<bool>((ref) => false);
