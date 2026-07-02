import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:psycolor/theme/app_colors.dart';

class ColorTile extends StatelessWidget {
  const ColorTile({
    super.key,
    required this.colorId,
    required this.rank,
    required this.onReorderUp,
    required this.onReorderDown,
  });

  final TestColorId colorId;
  final int rank;
  final VoidCallback? onReorderUp;
  final VoidCallback? onReorderDown;

  @override
  Widget build(BuildContext context) {
    final color = colorId.color;
    final labelColor = _textColorForBackground(color);

    return Semantics(
      label: '${colorId.name}, rank $rank',
      child: Container(
        height: 72,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.45),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: labelColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      colorId.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: labelColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      colorId.trait,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: labelColor.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              _ReorderButton(
                icon: Icons.keyboard_arrow_up_rounded,
                labelColor: labelColor,
                onPressed: onReorderUp,
              ),
              _ReorderButton(
                icon: Icons.keyboard_arrow_down_rounded,
                labelColor: labelColor,
                onPressed: onReorderDown,
              ),
            ],
          ),
        ),
      )
          .animate(key: ValueKey('${colorId.storageKey}_$rank'))
          .fadeIn(duration: 180.ms, curve: Curves.easeOut)
          .slideY(begin: 0.04, end: 0, duration: 180.ms, curve: Curves.easeOut),
    );
  }

  Color _textColorForBackground(Color bg) {
    return bg.computeLuminance() > 0.45 ? const Color(0xFF1F2937) : Colors.white;
  }
}

class _ReorderButton extends StatelessWidget {
  const _ReorderButton({
    required this.icon,
    required this.labelColor,
    required this.onPressed,
  });

  final IconData icon;
  final Color labelColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled
            ? () {
                HapticFeedback.lightImpact();
                onPressed!();
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: 26,
            color: enabled
                ? labelColor.withValues(alpha: 0.95)
                : labelColor.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}
