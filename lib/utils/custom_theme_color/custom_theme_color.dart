import 'package:flutter/material.dart';

@immutable
class CustomThemeColor extends ThemeExtension<CustomThemeColor> {
  const CustomThemeColor({
    this.shimmerBaseColor = const Color(0xFFE0E0E0),
    this.shimmerHighlightColor = const Color(0xFFF5F5F5),
  });

  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;

  @override
  CustomThemeColor copyWith({
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
  }) {
    return CustomThemeColor(
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor:
          shimmerHighlightColor ?? this.shimmerHighlightColor,
    );
  }

  @override
  CustomThemeColor lerp(ThemeExtension<CustomThemeColor>? other, double t) {
    if (other is! CustomThemeColor) return this;
    return CustomThemeColor(
      shimmerBaseColor:
          Color.lerp(shimmerBaseColor, other.shimmerBaseColor, t)!,
      shimmerHighlightColor:
          Color.lerp(shimmerHighlightColor, other.shimmerHighlightColor, t)!,
    );
  }
}
