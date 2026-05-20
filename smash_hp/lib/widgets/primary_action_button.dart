import 'package:flutter/material.dart';
import 'pixel_button.dart';

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return PixelButton(
      label: label,
      onPressed: onPressed,
      isPrimary: true,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      textColor: textColor,
    );
  }
}
