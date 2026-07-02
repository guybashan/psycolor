import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/app_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/gradient_background.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future<void>.delayed(2200.ms);
    if (!mounted) return;

    ref.read(creditBalanceProvider.notifier).refresh();
    ref.read(historyProvider.notifier).refresh();

    final settings = ref.read(settingsServiceProvider);
    if (settings.hasSeenOnboarding) {
      context.go('/home');
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      glowColor1: AppColors.glowPink,
      glowColor2: AppColors.glowViolet,
      glowColor3: AppColors.glowCyan,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AppIconMark()
                  .animate()
                  .scale(
                    begin: const Offset(0.6, 0.6),
                    end: const Offset(1, 1),
                    duration: 800.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: 600.ms),
              const SizedBox(height: 32),
              Text(
                'PsyColor',
                style: Theme.of(context).textTheme.displayMedium,
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 8),
              Text(
                'Discover yourself through color',
                style: Theme.of(context).textTheme.bodyLarge,
              )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppIconMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentSecondary.withValues(alpha: 0.35),
            blurRadius: 36,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          'assets/icon/app_icon.png',
          fit: BoxFit.cover,
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.04, 1.04),
          duration: 2.seconds,
          curve: Curves.easeInOut,
        );
  }
}
