import 'package:psycolor/models/credit_package.dart';

abstract class PurchaseService {
  Future<PurchaseResult> purchase(CreditPackage package);
}

class PurchaseResult {
  const PurchaseResult({required this.success, this.creditsGranted = 0});

  final bool success;
  final int creditsGranted;
}
