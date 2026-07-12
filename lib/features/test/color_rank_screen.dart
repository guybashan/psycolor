import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/app_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/color_tile.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';
import 'package:psycolor/widgets/quick_drag_start_listener.dart';

class ColorRankScreen extends ConsumerWidget {
  const ColorRankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(testSessionProvider);
    final notifier = ref.read(testSessionProvider.notifier);
    final isPass1 = session.pass == 1;

    return GradientBackground(
      glowColor1: isPass1 ? AppColors.glowBlue : AppColors.glowViolet,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text('Pass ${session.pass} of 2'),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedSwitcher(
                  duration: 400.ms,
                  child: Text(
                    isPass1
                        ? 'How do you feel right now?'
                        : 'How do you want to feel?',
                    key: ValueKey(session.pass),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Hold & drag to rank — most preferred at the top.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  buildDefaultDragHandles: false,
                  itemCount: session.currentOrder.length,
                  onReorder: (oldIndex, newIndex) {
                    HapticFeedback.mediumImpact();
                    notifier.reorder(oldIndex, newIndex);
                  },
                  proxyDecorator: (child, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, _) {
                        final t = Curves.easeOut
                            .transform(animation.value);
                        return Transform.scale(
                          scale: 1 + 0.04 * t,
                          child: child,
                        );
                      },
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final colorId = session.currentOrder[index];
                    return QuickDragStartListener(
                      key: ValueKey('${session.pass}_${colorId.storageKey}'),
                      index: index,
                      child: ColorTile(
                        colorId: colorId,
                        rank: index + 1,
                        onReorderUp:
                            index > 0 ? () => notifier.moveUp(index) : null,
                        onReorderDown: index < session.currentOrder.length - 1
                            ? () => notifier.moveDown(index)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PrimaryButton(
                  label: isPass1 ? 'Continue to pass 2' : 'See my results',
                  onPressed: () {
                    final finished = notifier.completePass();
                    if (finished) {
                      context.push('/test/analyzing');
                    }
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
