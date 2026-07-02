import 'package:flutter/material.dart';
import 'package:psycolor/theme/app_colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.glowColor1 = AppColors.glowPink,
    this.glowColor2 = AppColors.glowBlue,
    this.glowColor3 = AppColors.glowYellow,
  });

  final Widget child;
  final Color glowColor1;
  final Color glowColor2;
  final Color glowColor3;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFF0F6),
                Color(0xFFF0F7FF),
                Color(0xFFFFFBE6),
                Color(0xFFF5EEFF),
              ],
              stops: [0, 0.35, 0.65, 1],
            ),
          ),
        ),
        Positioned(
          top: -100,
          left: -60,
          child: _GlowOrb(color: glowColor1, size: 340),
        ),
        Positioned(
          top: 120,
          right: -80,
          child: _GlowOrb(color: glowColor2, size: 300),
        ),
        Positioned(
          bottom: -80,
          left: 40,
          child: _GlowOrb(color: glowColor3, size: 260),
        ),
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}
