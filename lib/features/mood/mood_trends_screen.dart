import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/models/mood_entry.dart';
import 'package:psycolor/providers/mood_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/glass_card.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';

class MoodTrendsScreen extends ConsumerWidget {
  const MoodTrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(moodEntriesProvider);
    final service = ref.read(moodServiceProvider);
    final today = DateTime.now();
    final todayEntry = ref.watch(todayMoodProvider);
    final streak = service.streak(entries, today);
    final lines = service.trendLines(entries, today);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/home'),
          ),
          title: const Text('Your color diary'),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              if (todayEntry != null) ...[
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: todayEntry.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Today',
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              '${todayEntry.tone} ${todayEntry.family}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      if (streak > 1)
                        Text(
                          '🔥 $streak days',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 14),
              ],
              Text('Last 30 days',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: _MonthStrip(entries: entries, today: today),
              ),
              const SizedBox(height: 14),
              Text('What your colors show',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.insights_outlined,
                            color: AppColors.accent, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(line,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                'Observations describe your own picks over time — color as a '
                'record of how your days felt, not a diagnosis.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              if (todayEntry == null)
                PrimaryButton(
                  label: "Log today's color",
                  onPressed: () => context.pushReplacement('/mood/checkin'),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthStrip extends StatelessWidget {
  const _MonthStrip({required this.entries, required this.today});

  final List<MoodEntry> entries;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final byKey = {for (final e in entries) e.dateKey: e};
    // Oldest first, ending today: 30 cells in a 6x5 grid.
    final days = [
      for (var i = 29; i >= 0; i--) today.subtract(Duration(days: i)),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 10,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: [
        for (final day in days)
          Builder(builder: (context) {
            final entry = byKey[MoodEntry.dateKeyFor(day)];
            return Container(
              decoration: BoxDecoration(
                color: entry?.color,
                borderRadius: BorderRadius.circular(6),
                border: entry == null
                    ? Border.all(
                        color: AppColors.textSecondary.withValues(alpha: 0.25),
                      )
                    : null,
              ),
            );
          }),
      ],
    );
  }
}
