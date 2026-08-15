import 'package:flutter/material.dart';

import '../../domain/entities/brand_theme.dart';
import '../utils/color_parser.dart';

class BrandThemeExtension extends ThemeExtension<BrandThemeExtension> {
  const BrandThemeExtension({
    required this.accent,
    required this.muted,
    required this.surfaceVariant,
    required this.success,
    required this.radius,
    required this.buttonShape,
    required this.cardStyle,
    required this.titleStyle,
  });

  final Color accent;
  final Color muted;
  final Color surfaceVariant;
  final Color success;
  final double radius;
  final ButtonShape buttonShape;
  final CardStyle cardStyle;
  final TitleStyle titleStyle;

  factory BrandThemeExtension.fromBrand(BrandTheme brand) {
    return BrandThemeExtension(
      accent: parseHexColor(brand.accentHex),
      muted: parseHexColor(brand.mutedHex),
      surfaceVariant: parseHexColor(brand.surfaceVariantHex),
      success: parseHexColor(brand.successHex),
      radius: brand.borderRadius,
      buttonShape: brand.buttonShape,
      cardStyle: brand.cardStyle,
      titleStyle: brand.titleStyle,
    );
  }

  OutlinedBorder get buttonBorder {
    final radius = BorderRadius.circular(switch (buttonShape) {
      ButtonShape.pill => 999,
      ButtonShape.square => 4,
      ButtonShape.rounded => this.radius,
    });
    return RoundedRectangleBorder(borderRadius: radius);
  }

  BorderRadius get cardRadius => BorderRadius.circular(radius);

  @override
  BrandThemeExtension copyWith({
    Color? accent,
    Color? muted,
    Color? surfaceVariant,
    Color? success,
    double? radius,
    ButtonShape? buttonShape,
    CardStyle? cardStyle,
    TitleStyle? titleStyle,
  }) {
    return BrandThemeExtension(
      accent: accent ?? this.accent,
      muted: muted ?? this.muted,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      success: success ?? this.success,
      radius: radius ?? this.radius,
      buttonShape: buttonShape ?? this.buttonShape,
      cardStyle: cardStyle ?? this.cardStyle,
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }

  @override
  BrandThemeExtension lerp(
    ThemeExtension<BrandThemeExtension>? other,
    double t,
  ) {
    if (other is! BrandThemeExtension) return this;
    return BrandThemeExtension(
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      muted: Color.lerp(muted, other.muted, t) ?? muted,
      surfaceVariant:
          Color.lerp(surfaceVariant, other.surfaceVariant, t) ?? surfaceVariant,
      success: Color.lerp(success, other.success, t) ?? success,
      radius: lerpDouble(radius, other.radius, t) ?? radius,
      buttonShape: t < 0.5 ? buttonShape : other.buttonShape,
      cardStyle: t < 0.5 ? cardStyle : other.cardStyle,
      titleStyle: t < 0.5 ? titleStyle : other.titleStyle,
    );
  }
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;

extension BrandThemeContext on BuildContext {
  BrandThemeExtension get brand {
    return Theme.of(this).extension<BrandThemeExtension>()!;
  }
}
