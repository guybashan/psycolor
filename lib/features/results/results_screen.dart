import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/models/test_result.dart';
import 'package:psycolor/providers/app_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/glass_card.dart';
import 'package:psycolor/widgets/primary_button.dart';
import 'package:share_plus/share_plus.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(testSessionProvider).result;

    if (result == null) {
      return Scaffold(
        body: Center(
          child: PrimaryButton(
            label: 'Go home',
            onPressed: () => context.go('/home'),
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _AuraHeader(result: result)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  result.archetype,
                  style: Theme.of(context).textTheme.displayMedium,
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),
                const SizedBox(height: 8),
                Text(
                  result.tagline,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.85),
                      ),
                ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
                const SizedBox(height: 28),
                ...result.sections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            section.body,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(
                          delay: (200 + index * 100).ms,
                          duration: 500.ms,
                        )
                        .slideY(begin: 0.08, end: 0),
                  );
                }),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Share profile',
                  icon: Icons.share_outlined,
                  onPressed: () => Share.share(result.shareText),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: 'Take test again',
                  onPressed: () {
                    ref.read(testSessionProvider.notifier).reset();
                    context.go('/home');
                  },
                ).animate().fadeIn(delay: 700.ms),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Back to home'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuraHeader extends StatelessWidget {
  const _AuraHeader({required this.result});

  final TestResult result;

  @override
  Widget build(BuildContext context) {
    final colors = result.auraColors.map((c) => c.color).toList();
    while (colors.length < 3) {
      colors.add(AppColors.accent);
    }

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors[0].withValues(alpha: 0.9),
            colors[1].withValues(alpha: 0.7),
            colors[2].withValues(alpha: 0.55),
            AppColors.background,
          ],
          stops: const [0, 0.35, 0.65, 1],
        ),
      ),
      child: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => context.go('/home'),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}
