import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/app_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';

class TestIntroScreen extends ConsumerWidget {
  const TestIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(creditBalanceProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: const Text('Before you begin'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Two passes,\none insight',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'You will rank 8 colors twice. There are no right or wrong answers—trust your first instinct.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                _StepRow(
                  number: '1',
                  title: 'How you feel now',
                  subtitle: 'Drag colors from most to least appealing.',
                ),
                const SizedBox(height: 16),
                _StepRow(
                  number: '2',
                  title: 'How you want to feel',
                  subtitle: 'Rank again with a fresh perspective.',
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceTint.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.accentSecondary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.accent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This test uses 1 credit. You have $balance.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Begin test',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () async {
                    final session = ref.read(testSessionProvider.notifier);
                    if (!ref.read(testSessionProvider).creditReserved) {
                      final ok = await ref
                          .read(creditBalanceProvider.notifier)
                          .deductForTest();
                      if (!ok) {
                        if (context.mounted) context.pop();
                        return;
                      }
                      session.markCreditReserved();
                    }
                    if (context.mounted) context.push('/test/rank');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.accentSecondary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.accentSecondary,
                ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
