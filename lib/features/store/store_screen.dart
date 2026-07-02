import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/models/credit_package.dart';
import 'package:psycolor/providers/app_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/credit_badge.dart';
import 'package:psycolor/widgets/glass_card.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  String? _purchasingId;
  bool _showSuccess = false;
  int _lastGranted = 0;

  Future<void> _purchase(CreditPackage package) async {
    setState(() => _purchasingId = package.id);
    ref.read(purchaseLoadingProvider.notifier).state = true;

    final result =
        await ref.read(purchaseServiceProvider).purchase(package);

    ref.read(purchaseLoadingProvider.notifier).state = false;

    if (result.success && result.creditsGranted > 0) {
      await ref
          .read(creditBalanceProvider.notifier)
          .grant(result.creditsGranted);
      setState(() {
        _purchasingId = null;
        _showSuccess = true;
        _lastGranted = result.creditsGranted;
      });
      await Future<void>.delayed(2.seconds);
      if (mounted) setState(() => _showSuccess = false);
    } else {
      setState(() => _purchasingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(creditBalanceProvider);

    return GradientBackground(
      glowColor1: AppColors.glowViolet,
      glowColor2: AppColors.glowBlue,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Get credits'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CreditBadge(balance: balance),
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unlock more\ninsights',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Each personality test uses 1 credit. Choose a pack that fits your journey.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: ListView.separated(
                        itemCount: creditPackages.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final package = creditPackages[index];
                          final isLoading = _purchasingId == package.id;
                          return _PackageCard(
                            package: package,
                            isLoading: isLoading,
                            onPurchase: () => _purchase(package),
                          )
                              .animate()
                              .fadeIn(delay: (index * 100).ms, duration: 500.ms)
                              .slideY(begin: 0.1, end: 0);
                        },
                      ),
                    ),
                    Tooltip(
                      message: 'Coming soon',
                      child: TextButton(
                        onPressed: null,
                        child: const Text('Restore purchases'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (_showSuccess) _SuccessOverlay(credits: _lastGranted),
          ],
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.isLoading,
    required this.onPurchase,
  });

  final CreditPackage package;
  final bool isLoading;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: package.isPopular ? 24 : 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                package.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (package.isPopular) ...[
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Most popular',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .shimmer(
                      duration: 2.seconds,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
              ],
              const Spacer(),
              Text(
                package.priceLabel,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 22,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${package.credits} credits',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.accent,
                ),
          ),
          if (package.description != null) ...[
            const SizedBox(height: 6),
            Text(
              package.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 16),
          PrimaryButton(
            label: isLoading ? 'Processing…' : 'Buy now',
            isLoading: isLoading,
            onPressed: isLoading ? null : onPurchase,
          ),
        ],
      ),
    );
  }
}

class _SuccessOverlay extends StatelessWidget {
  const _SuccessOverlay({required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 64, color: AppColors.accent)
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    curve: Curves.elasticOut,
                    duration: 600.ms,
                  ),
              const SizedBox(height: 16),
              Text(
                'Credits added!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '+$credits credits',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.accent,
                    ),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                8,
                (i) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: [
                      AppColors.testBlue,
                      AppColors.testViolet,
                      AppColors.testRed,
                      AppColors.testYellow,
                      AppColors.testGreen,
                      AppColors.testBrown,
                      AppColors.testGray,
                      AppColors.accent,
                    ][i],
                  ),
                )
                    .animate(delay: (i * 50).ms)
                    .fadeIn()
                    .scale(begin: const Offset(0, 0), curve: Curves.elasticOut),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
