import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/app_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/gradient_background.dart';

class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen> {
  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    await Future<void>.delayed(2500.ms);

    final session = ref.read(testSessionProvider);
    final pass1 = session.pass1Order;
    final pass2 = session.pass2Order;

    if (pass1 == null || pass2 == null) {
      if (mounted) context.go('/home');
      return;
    }

    final result = ref.read(testScoringServiceProvider).score(
          pass1Order: pass1,
          pass2Order: pass2,
        );

    ref.read(testSessionProvider.notifier).setResult(result);
    await ref.read(historyProvider.notifier).add(result);

    if (mounted) context.go('/results');
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      glowColor1: AppColors.glowViolet,
      glowColor2: AppColors.glowOrange,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (var i = 0; i < 4; i++)
                      _OrbitDot(
                        color: [
                          AppColors.testBlue,
                          AppColors.testViolet,
                          AppColors.testRed,
                          AppColors.testYellow,
                        ][i],
                        delay: Duration(milliseconds: i * 200),
                      ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Reading your choices…',
                style: Theme.of(context).textTheme.headlineMedium,
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fade(begin: 0.5, end: 1, duration: 1.seconds),
              const SizedBox(height: 12),
              Text(
                'Mapping colors to your inner world',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrbitDot extends StatelessWidget {
  const _OrbitDot({required this.color, required this.delay});

  final Color color;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 12),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(), delay: delay)
        .moveY(begin: -50, end: 50, duration: 1.2.seconds, curve: Curves.easeInOut)
        .then()
        .moveY(begin: 50, end: -50, duration: 1.2.seconds, curve: Curves.easeInOut);
  }
}
