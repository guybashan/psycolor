import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/mood_providers.dart';
import 'package:psycolor/services/mood_service.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';

class MoodCheckinScreen extends ConsumerStatefulWidget {
  const MoodCheckinScreen({super.key});

  @override
  ConsumerState<MoodCheckinScreen> createState() => _MoodCheckinScreenState();
}

class _MoodCheckinScreenState extends ConsumerState<MoodCheckinScreen> {
  MoodSwatch? _selected;

  @override
  Widget build(BuildContext context) {
    final palette = ref.read(moodServiceProvider).palette();
    final already = ref.watch(todayMoodProvider) != null;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: const Text("Today's color"),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  already
                      ? 'Changed your mind? Pick again — today\'s color can '
                          'be updated until midnight.'
                      : 'Which color matches how you feel right now? '
                          'Don\'t reason about it — just pick.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.9,
                  children: [
                    for (final swatch in palette)
                      _SwatchTile(
                        swatch: swatch,
                        selected: _selected == swatch,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selected = swatch);
                        },
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PrimaryButton(
                  label: _selected == null ? 'Pick a color' : 'Log today\'s color',
                  onPressed: _selected == null
                      ? null
                      : () async {
                          await ref
                              .read(moodEntriesProvider.notifier)
                              .checkIn(_selected!);
                          if (context.mounted) {
                            context.pushReplacement('/mood/trends');
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

class _SwatchTile extends StatelessWidget {
  const _SwatchTile({
    required this.swatch,
    required this.selected,
    required this.onTap,
  });

  final MoodSwatch swatch;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: swatch.color,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: AppColors.textPrimary, width: 3)
              : Border.all(
                  color: Colors.black.withValues(alpha: 0.06),
                ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: swatch.color.withValues(alpha: 0.5),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: selected
            ? Icon(
                Icons.check,
                color: swatch.color.computeLuminance() > 0.45
                    ? const Color(0xFF1F2937)
                    : Colors.white,
              )
            : null,
      ),
    );
  }
}
