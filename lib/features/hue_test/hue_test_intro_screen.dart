import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/hue_test_providers.dart';
import 'package:psycolor/services/hue_test_service.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';

class HueTestIntroScreen extends ConsumerWidget {
  const HueTestIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordered = const HueTestService().orderedTiles();

    return GradientBackground(
      glowColor1: AppColors.glowBlue,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: const Text('Color vision test'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'How finely can you\nsee hue?',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Arrange the shades into a smooth color sequence between '
                  'the two fixed ends. The closer your order is to the true '
                  'hue sequence, the higher your score.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                // Preview strip of the solved gradient.
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      for (final tile in ordered)
                        Expanded(child: Container(height: 40, color: tile.color)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _InfoRow(
                  icon: Icons.lock_outline,
                  text: 'The first and last shades are fixed anchors.',
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.touch_app_outlined,
                  text: 'Hold a shade briefly, then drag it into place.',
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.timer_off_outlined,
                  text: 'No time limit — precision is what counts.',
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.science_outlined,
                  text: 'Based on the Farnsworth–Munsell hue arrangement method.',
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Start — free',
                  onPressed: () {
                    ref.read(hueTestProvider.notifier).reset();
                    context.push('/hue/test');
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
