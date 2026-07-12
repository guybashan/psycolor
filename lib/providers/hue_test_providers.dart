import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psycolor/models/hue_test_result.dart';
import 'package:psycolor/services/hue_history_service.dart';
import 'package:psycolor/services/hue_test_service.dart';

final hueTestServiceProvider = Provider<HueTestService>(
  (ref) => const HueTestService(),
);

final hueHistoryServiceProvider = Provider<HueHistoryService>((ref) {
  return HueHistoryService(Hive.box('hue_history'));
});

final hueHistoryProvider =
    StateNotifierProvider<HueHistoryNotifier, List<HueTestResult>>((ref) {
  return HueHistoryNotifier(ref.watch(hueHistoryServiceProvider));
});

class HueHistoryNotifier extends StateNotifier<List<HueTestResult>> {
  HueHistoryNotifier(this._service) : super(_service.getAll());

  final HueHistoryService _service;

  Future<void> add(HueTestResult result) async {
    await _service.save(result);
    state = _service.getAll();
  }
}

class HueTestState {
  HueTestState({required this.tiles, this.result});

  /// Current arrangement, anchors included at both ends.
  final List<HueTile> tiles;
  final HueTestResult? result;

  HueTestState copyWith({List<HueTile>? tiles, HueTestResult? result}) {
    return HueTestState(tiles: tiles ?? this.tiles, result: result ?? this.result);
  }
}

final hueTestProvider =
    StateNotifierProvider<HueTestNotifier, HueTestState>((ref) {
  return HueTestNotifier(ref.watch(hueTestServiceProvider));
});

class HueTestNotifier extends StateNotifier<HueTestState> {
  HueTestNotifier(this._service)
      : super(HueTestState(tiles: _service.shuffledTiles()));

  final HueTestService _service;

  void reset() {
    state = HueTestState(tiles: _service.shuffledTiles());
  }

  /// Reorder with [ReorderableListView] index semantics. The first and last
  /// tiles are fixed anchors and can neither move nor be displaced.
  void reorder(int oldIndex, int newIndex) {
    final last = state.tiles.length - 1;
    if (oldIndex == 0 || oldIndex == last) return;
    if (newIndex > oldIndex) newIndex -= 1;
    final clamped = newIndex.clamp(1, last - 1);
    final tiles = List<HueTile>.from(state.tiles);
    final tile = tiles.removeAt(oldIndex);
    tiles.insert(clamped, tile);
    state = state.copyWith(tiles: tiles);
  }

  /// Scores the current arrangement and stores it as the session result.
  HueTestResult complete() {
    final error = _service.totalError(state.tiles);
    final result = HueTestResult(
      accuracy: _service.accuracy(state.tiles),
      totalError: error,
      band: _service.band(error),
      displacements: _service.displacements(state.tiles),
      createdAt: DateTime.now(),
    );
    state = state.copyWith(result: result);
    return result;
  }
}
