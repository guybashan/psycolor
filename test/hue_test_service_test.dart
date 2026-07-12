import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:psycolor/services/hue_test_service.dart';

void main() {
  const service = HueTestService();

  group('tile generation', () {
    test('produces the expected number of tiles', () {
      expect(service.orderedTiles().length, HueTestService.tileCount);
    });

    test('all colors are valid opaque sRGB', () {
      for (final tile in service.orderedTiles()) {
        expect(tile.color.a, 1.0);
      }
    });

    test('adjacent tiles differ (hue steps are visible)', () {
      final tiles = service.orderedTiles();
      for (var i = 1; i < tiles.length; i++) {
        expect(tiles[i].color, isNot(equals(tiles[i - 1].color)),
            reason: 'tiles $i and ${i - 1} must be distinguishable');
      }
    });

    test('correctIndex matches generation order', () {
      final tiles = service.orderedTiles();
      for (var i = 0; i < tiles.length; i++) {
        expect(tiles[i].correctIndex, i);
      }
    });
  });

  group('shuffle', () {
    test('keeps anchors in place and is never already solved', () {
      for (var seed = 0; seed < 25; seed++) {
        final tiles = service.shuffledTiles(Random(seed));
        expect(tiles.first.correctIndex, 0);
        expect(tiles.last.correctIndex, HueTestService.tileCount - 1);
        expect(service.totalError(tiles), greaterThan(0));
      }
    });
  });

  group('scoring', () {
    test('perfect arrangement scores 0 error and 100 accuracy', () {
      final tiles = service.orderedTiles();
      expect(service.totalError(tiles), 0);
      expect(service.accuracy(tiles), 100);
    });

    test('full reversal of movable tiles scores maxError and 0 accuracy', () {
      final tiles = service.orderedTiles();
      final reversed = [
        tiles.first,
        ...tiles.sublist(1, tiles.length - 1).reversed,
        tiles.last,
      ];
      expect(service.totalError(reversed), service.maxError);
      expect(service.accuracy(reversed), 0);
    });

    test('single adjacent swap costs 2', () {
      final tiles = service.orderedTiles();
      final swapped = List<HueTile>.from(tiles);
      final tmp = swapped[5];
      swapped[5] = swapped[6];
      swapped[6] = tmp;
      expect(service.totalError(swapped), 2);
    });

    test('bands are monotonic in error', () {
      expect(service.band(0), 'Superior discrimination');
      expect(service.band(2), 'Excellent discrimination');
      expect(service.band(10), 'Typical discrimination');
      expect(service.band(20), 'Below-average discrimination');
      expect(service.band(60), 'Low discrimination');
    });
  });
}
