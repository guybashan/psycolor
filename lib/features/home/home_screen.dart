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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(creditBalanceProvider);
    final history = ref.watch(historyProvider);
    final recent = history.take(3).toList();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PsyColor',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    CreditBadge(balance: balance),
                  ],
                ),
                const SizedBox(height: 32),
                _HeroTestCard(
                  onTap: () => context.push('/hue/intro'),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 12),
                _ClassicTestCard(
                  onTap: () => _startTest(context, ref, balance),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 120.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),
                Text(
                  'Recent results',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: recent.isEmpty
                      ? _EmptyHistory()
                      : ListView.separated(
                          itemCount: recent.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final result = recent[index];
                            return GlassCard(
                              onTap: () {
                                ref
                                    .read(testSessionProvider.notifier)
                                    .setResult(result);
                                context.push('/results');
                              },
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  _AuraDot(colors: result.auraColors),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          result.archetype,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          _formatDate(result.createdAt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ShortcutButton(
                        icon: Icons.history,
                        label: 'History',
                        onTap: () => context.push('/history'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ShortcutButton(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Store',
                        onTap: () => context.push('/store'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startTest(BuildContext context, WidgetRef ref, int balance) {
    if (balance < testCreditCost) {
      _showInsufficientCredits(context);
      return;
    }
    ref.read(testSessionProvider.notifier).reset();
    context.push('/test/intro');
  }

  void _showInsufficientCredits(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 48, color: AppColors.accent),
            const SizedBox(height: 16),
            Text(
              'You need more credits',
              style: Theme.of(ctx).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Each test uses 1 credit. Grab a pack to continue your journey.',
              textAlign: TextAlign.center,
              style: Theme.of(ctx).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Visit store',
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/store');
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _HeroTestCard extends StatelessWidget {
  const _HeroTestCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.heroGradient,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentSecondary.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Color vision test',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 26,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Arrange 20 shades by hue and measure how finely you '
              'discriminate color.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Free',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .boxShadow(
          begin: BoxShadow(
            color: AppColors.accentSecondary.withValues(alpha: 0.25),
            blurRadius: 20,
          ),
          end: BoxShadow(
            color: AppColors.accentSecondary.withValues(alpha: 0.45),
            blurRadius: 32,
          ),
          duration: 2.seconds,
        );
  }
}

class _ClassicTestCard extends StatelessWidget {
  const _ClassicTestCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.psychology_outlined,
              color: AppColors.accent, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Classic color reflection',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'The traditional two-pass ranking — for self-reflection, '
                  'not measurement. 1 credit.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.color_lens_outlined,
            size: 56,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Take your first test to see your color profile here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accent, size: 20),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _AuraDot extends StatelessWidget {
  const _AuraDot({required this.colors});

  final List<TestColorId> colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        children: [
          for (var i = 0; i < colors.length && i < 3; i++)
            Positioned(
              left: i * 10.0,
              top: i * 4.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[i].color,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
