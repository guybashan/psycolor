import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/hue_test_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/glass_card.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';

class HueResultsScreen extends ConsumerStatefulWidget {
  const HueResultsScreen({super.key});

  @override
  ConsumerState<HueResultsScreen> createState() => _HueResultsScreenState();
}

class _HueResultsScreenState extends ConsumerState<HueResultsScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    // Persist once when the screen first shows.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final result = ref.read(hueTestProvider).result;
      if (result != null && !_saved) {
        _saved = true;
        ref.read(hueHistoryProvider.notifier).add(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hueTestProvider);
    final result = state.result;
    final history = ref.watch(hueHistoryProvider);

    if (result == null) {
      return const SizedBox.shrink();
    }

    final best = history.isEmpty
        ? result.accuracy
        : history.map((r) => r.accuracy).reduce((a, b) => a > b ? a : b);

    return GradientBackground(
      glowColor1: AppColors.glowBlue,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/home'),
          ),
          title: const Text('Your result'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  '${result.accuracy}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 88,
                        fontWeight: FontWeight.w700,
                      ),
                ).animate().fadeIn(duration: 400.ms).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      curve: Curves.easeOutBack,
                      duration: 500.ms,
                    ),
                Text(
                  'hue accuracy',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  result.band,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Where your order drifted',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Taller bars mean a shade landed farther from its true '
                        'position.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 64,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (var i = 0;
                                i < state.tiles.length;
                                i++) ...[
                              Expanded(
                                child: Container(
                                  height: 6.0 +
                                      58.0 *
                                          (result.displacements[i] /
                                              (state.tiles.length / 2)),
                                  decoration: BoxDecoration(
                                    color: state.tiles[i].color,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                              if (i < state.tiles.length - 1)
                                const SizedBox(width: 2),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events_outlined,
                          color: AppColors.accent),
                      const SizedBox(width: 12),
                      Text(
                        'Personal best: $best',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        'attempt ${history.length}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Method: hue arrangement after Farnsworth (1943). Score '
                  'reflects how closely your order matches the true hue '
                  'sequence. Screen quality and lighting affect results.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'Try again',
                  onPressed: () {
                    ref.read(hueTestProvider.notifier).reset();
                    context.pushReplacement('/hue/test');
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
