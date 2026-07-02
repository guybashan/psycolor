import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/providers/app_providers.dart';
import 'package:psycolor/theme/app_colors.dart';
import 'package:psycolor/widgets/gradient_background.dart';
import 'package:psycolor/widgets/primary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _WelcomePageData(
      icon: Icons.palette_outlined,
      title: 'Discover yourself\nthrough color',
      subtitle:
          'Ancient color psychology meets modern design. Uncover traits you feel but rarely name.',
      glow: AppColors.glowBlue,
    ),
    _WelcomePageData(
      icon: Icons.swap_vert,
      title: 'Rank 8 colors\ntwice',
      subtitle:
          'First how you feel now, then how you wish to feel. Your order reveals your inner landscape.',
      glow: AppColors.glowViolet,
    ),
    _WelcomePageData(
      icon: Icons.auto_awesome,
      title: 'Get your\npersonal profile',
      subtitle:
          'Receive a rich archetype, trait insights, and a unique color aura—yours to keep and share.',
      glow: AppColors.glowOrange,
    ),
  ];

  Future<void> _finish(WidgetRef ref) async {
    await ref.read(settingsServiceProvider).setHasSeenOnboarding(true);
    if (mounted) context.go('/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return GradientBackground(
          glowColor1: _pages[_page].glow,
          glowColor2: AppColors.glowViolet,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => _finish(ref),
                      child: const Text('Skip'),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (i) => setState(() => _page = i),
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(page.icon, size: 80, color: AppColors.accent)
                                  .animate()
                                  .fadeIn(duration: 500.ms)
                                  .scale(
                                    begin: const Offset(0.8, 0.8),
                                    curve: Curves.easeOutBack,
                                  ),
                              const SizedBox(height: 40),
                              Text(
                                page.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayMedium,
                              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.15),
                              const SizedBox(height: 16),
                              Text(
                                page.subtitle,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ).animate().fadeIn(delay: 200.ms),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _page == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i
                              ? AppColors.accent
                              : AppColors.textSecondary.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PrimaryButton(
                      label: _page == _pages.length - 1 ? 'Get started' : 'Next',
                      onPressed: () {
                        if (_page == _pages.length - 1) {
                          _finish(ref);
                        } else {
                          _controller.nextPage(
                            duration: 400.ms,
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WelcomePageData {
  const _WelcomePageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.glow,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color glow;
}
