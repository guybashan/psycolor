import 'package:flutter/material.dart';
import 'package:psycolor/models/credit_package.dart';
import 'package:psycolor/services/purchase_service.dart';
import 'package:psycolor/theme/app_colors.dart';

class MockPurchaseService implements PurchaseService {
  MockPurchaseService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Future<PurchaseResult> purchase(CreditPackage package) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return const PurchaseResult(success: false);
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Purchase ${package.title}?'),
        content: Text(
          'Mock purchase: ${package.credits} credits for ${package.priceLabel}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return const PurchaseResult(success: false);
    }

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    return PurchaseResult(success: true, creditsGranted: package.credits);
  }
}
