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
    const color = MinecraftTheme.healthGreen;
    const darkColor = Color(0xFF188D35);

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF1D1915)),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: const BoxDecoration(
                color: color,
                border: Border(right: BorderSide(color: darkColor, width: 2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
