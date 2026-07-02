import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:psycolor/features/history/history_screen.dart';
import 'package:psycolor/features/home/home_screen.dart';
import 'package:psycolor/features/onboarding/welcome_screen.dart';
import 'package:psycolor/features/results/results_screen.dart';
import 'package:psycolor/features/splash/splash_screen.dart';
import 'package:psycolor/features/store/store_screen.dart';
import 'package:psycolor/features/test/analyzing_screen.dart';
import 'package:psycolor/features/test/color_rank_screen.dart';
import 'package:psycolor/features/test/test_intro_screen.dart';
import 'package:psycolor/providers/app_providers.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/test/intro',
        builder: (context, state) => const TestIntroScreen(),
      ),
      GoRoute(
        path: '/test/rank',
        builder: (context, state) => const ColorRankScreen(),
      ),
      GoRoute(
        path: '/test/analyzing',
        builder: (context, state) => const AnalyzingScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: '/store',
        builder: (context, state) => const StoreScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );
});
