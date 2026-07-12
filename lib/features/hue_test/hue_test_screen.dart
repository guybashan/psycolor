import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/hue_test_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';
import 'package:psycolor/widgets/quick_drag_start_listener.dart';

class HueTestScreen extends ConsumerWidget {
  const HueTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hueTestProvider);
    final notifier = ref.read(hueTestProvider.notifier);
    final lastIndex = state.tiles.length - 1;

    return GradientBackground(
      glowColor1: AppColors.glowBlue,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Arrange by hue'),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Drag the shades into a smooth sequence between the two '
                  'locked ends.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  buildDefaultDragHandles: false,
                  itemCount: state.tiles.length,
                  onReorder: (oldIndex, newIndex) {
                    HapticFeedback.mediumImpact();
                    notifier.reorder(oldIndex, newIndex);
                  },
                  proxyDecorator: (child, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, _) {
                        final t = Curves.easeOut.transform(animation.value);
                        return Transform.scale(scale: 1 + 0.04 * t, child: child);
                      },
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final tile = state.tiles[index];
                    final isAnchor = index == 0 || index == lastIndex;
                    final bar = _HueBar(
                      color: tile.color,
                      isAnchor: isAnchor,
                    );
                    if (isAnchor) {
                      return KeyedSubtree(
                        key: ValueKey('anchor_${tile.correctIndex}'),
                        child: bar,
                      );
                    }
                    return QuickDragStartListener(
                      key: ValueKey('tile_${tile.correctIndex}'),
                      index: index,
                      child: bar,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PrimaryButton(
                  label: 'Done — score my order',
                  onPressed: () {
                    ref.read(hueTestProvider.notifier).complete();
                    context.push('/hue/results');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HueBar extends StatelessWidget {
  const _HueBar({required this.color, required this.isAnchor});

  final Color color;
  final bool isAnchor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: isAnchor
            ? Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2)
            : null,
      ),
      child: isAnchor
          ? const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.lock, size: 16, color: Colors.white),
              ),
            )
          : null,
    );
  }
}
