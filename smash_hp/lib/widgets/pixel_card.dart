import 'package:flutter/material.dart';
import '../theme/minecraft_theme.dart';

class PixelCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final double shadowOffset;

  const PixelCard({
    required this.child,
    this.borderColor = MinecraftTheme.deepStoneCharcoal,
    this.backgroundColor = MinecraftTheme.warmCream,
    this.borderWidth = MinecraftTheme.chunkBorderWidth,
    this.padding = const EdgeInsets.all(MinecraftTheme.pixelGridSize),
    this.shadowOffset = 3.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.4),
            offset: Offset(shadowOffset, shadowOffset),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class PixelPanelHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color backgroundColor;
  final Color borderColor;

  const PixelPanelHeader({
    required this.title,
    this.onTap,
    this.trailing,
    this.backgroundColor = MinecraftTheme.stoneBrown,
    this.borderColor = MinecraftTheme.darkGreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: borderColor,
              width: MinecraftTheme.chunkBorderWidth,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: MinecraftTheme.pixelGridSize,
          vertical: MinecraftTheme.pixelGridSize * 0.75,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MinecraftTheme.textLight,
                letterSpacing: 0.5,
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// Collapsible pixel panel for battle log
class CollapsiblePixelPanel extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Color headerColor;
  final Color borderColor;

  const CollapsiblePixelPanel({
    required this.title,
    required this.children,
    this.initiallyExpanded = true,
    this.headerColor = MinecraftTheme.stoneBrown,
    this.borderColor = MinecraftTheme.darkGreen,
    super.key,
  });

  @override
  State<CollapsiblePixelPanel> createState() => _CollapsiblePixelPanelState();
}

class _CollapsiblePixelPanelState extends State<CollapsiblePixelPanel> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor,
          width: MinecraftTheme.chunkBorderWidth,
        ),
      ),
      child: Column(
        children: [
          PixelPanelHeader(
            title: widget.title,
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: MinecraftTheme.textLight,
              size: 20,
            ),
            backgroundColor: widget.headerColor,
            borderColor: widget.borderColor,
          ),
          if (_isExpanded)
            Container(
              color: MinecraftTheme.textLight,
              child: Column(children: widget.children),
            ),
        ],
      ),
    );
  }
}
