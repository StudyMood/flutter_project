import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = color ?? (isDark ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.85));
    final defaultBorder = borderColor ?? (isDark ? Colors.white.withOpacity(0.12) : const Color(0xFFFF6B00).withOpacity(0.2));

    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: defaultBorder,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFFF6B00).withOpacity(0.06),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }
    return content;
  }
}
