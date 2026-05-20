import 'package:flutter/material.dart';
import '../theme/minecraft_theme.dart';

class PixelButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDisabled;
  final double padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  const PixelButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDisabled = false,
    this.padding = MinecraftTheme.pixelGridSize,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    super.key,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDisabled
        ? Colors.grey.shade400
        : widget.backgroundColor ??
              (widget.isPrimary
                  ? MinecraftTheme.primaryGold
                  : MinecraftTheme.deepStoneCharcoal);

    final borderColor = widget.isDisabled
        ? Colors.grey.shade600
        : widget.borderColor ?? MinecraftTheme.deepStoneCharcoal;

    final textColor = widget.isDisabled
        ? MinecraftTheme.textLight
        : widget.textColor ?? MinecraftTheme.textLight;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTapDown: (_) {
          if (!widget.isDisabled) {
            setState(() => _isPressed = true);
          }
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          if (!widget.isDisabled) {
            widget.onPressed();
          }
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
        },
        child: Transform.translate(
          offset: _isPressed ? const Offset(2, 2) : Offset.zero,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(
                color: borderColor,
                width: MinecraftTheme.chunkBorderWidth,
              ),
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: borderColor.withValues(alpha: 0.5),
                        offset: const Offset(2, 2),
                        blurRadius: 0,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: widget.padding,
              vertical: widget.padding * 0.75,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
