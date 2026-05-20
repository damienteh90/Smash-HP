import 'package:flutter/material.dart';
import '../theme/minecraft_theme.dart';

class HpBar extends StatelessWidget {
  final int currentHp;
  final int maxHp;
  final double height;

  const HpBar({
    required this.currentHp,
    required this.maxHp,
    this.height = 32.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = maxHp == 0 ? 0.0 : (currentHp / maxHp).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: MinecraftTheme.deepStoneCharcoal,
          width: MinecraftTheme.chunkBorderWidth,
        ),
        color: MinecraftTheme.deepStoneCharcoal,
        boxShadow: [
          BoxShadow(
            color: MinecraftTheme.deepStoneCharcoal.withValues(alpha: 0.5),
            offset: const Offset(2, 2),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
      ),
      height: height,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: percentage),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        builder: (context, animatedPercentage, child) {
          final fillColor = _getFillColor(animatedPercentage);
          final edgeColor = Color.lerp(
            fillColor,
            MinecraftTheme.deepStoneCharcoal,
            0.35,
          )!;

          return Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: Color(0xFF1D1915)),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: animatedPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    border: Border(
                      right: BorderSide(color: edgeColor, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getFillColor(double percentage) {
    if (percentage >= 0.70) {
      return MinecraftTheme.hpGreen;
    }
    if (percentage >= 0.40) {
      return MinecraftTheme.primaryGold;
    }
    if (percentage >= 0.15) {
      return MinecraftTheme.accentOrange;
    }
    return MinecraftTheme.battleRed;
  }
}
