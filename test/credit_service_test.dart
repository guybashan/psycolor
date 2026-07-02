import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:psycolor/models/credit_package.dart';
import 'package:psycolor/services/credit_service.dart';

void main() {
  late Box<dynamic> box;
  late CreditService service;

  setUp(() async {
    Hive.init('./test_hive');
    box = await Hive.openBox('test_credits');
    await box.clear();
    service = CreditService(box);
    await service.initialize();
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  test('initializes with starting credits', () {
    expect(service.balance, initialCredits);
  });

  test('deduct returns false when insufficient', () async {
    await box.put('balance', 0);
    expect(await service.deduct(testCreditCost), isFalse);
    expect(service.balance, 0);
  });

  test('deduct reduces balance when sufficient', () async {
    await box.put('balance', 2);
    expect(await service.deduct(testCreditCost), isTrue);
    expect(service.balance, 1);
  });

  test('grant increases balance', () async {
    await box.put('balance', 1);
    await service.grant(10);
    expect(service.balance, 11);
  });
}
