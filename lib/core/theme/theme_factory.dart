import 'package:flutter/material.dart';

import '../../domain/entities/brand_theme.dart';
import '../utils/color_parser.dart';
import 'brand_theme_extension.dart';

class ThemeFactory {
  const ThemeFactory._();

  static ThemeData platform() {
    const seed = Color(0xFF111827);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: const Color(0xFF111827),
        primary: const Color(0xFFE5E7EB),
      ),
      splashFactory: InkRipple.splashFactory,
      scaffoldBackgroundColor: const Color(0xFF0B1220),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xFFF9FAFB),
      ),
    );
  }

  static ThemeData fromBrand(BrandTheme brand) {
    final brightness = brand.brightness == ThemeBrightness.light
        ? Brightness.light
        : Brightness.dark;
    final primary = parseHexColor(brand.primaryHex);
    final secondary = parseHexColor(brand.secondaryHex);
    final background = parseHexColor(brand.backgroundHex);
    final surface = parseHexColor(brand.surfaceHex);
    final onPrimary = parseHexColor(brand.onPrimaryHex);
    final onBackground = parseHexColor(brand.onBackgroundHex);
    final onSurface = parseHexColor(brand.onSurfaceHex);
    final error = parseHexColor(brand.errorHex);
    final extension = BrandThemeExtension.fromBrand(brand);

    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onPrimary,
      error: error,
      onError: onPrimary,
      surface: surface,
      onSurface: onSurface,
    );

    final textTheme = _textTheme(brand.titleStyle, onBackground);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      splashFactory: InkRipple.splashFactory,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: brand.cardStyle == CardStyle.elevated ? 8 : 0,
        shadowColor: primary.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(
          borderRadius: extension.cardRadius,
          side: brand.cardStyle == CardStyle.outlined
              ? BorderSide(color: primary.withValues(alpha: 0.35))
              : BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      dividerColor: extension.muted.withValues(alpha: 0.3),
      chipTheme: ChipThemeData(
        backgroundColor: extension.surfaceVariant,
        labelStyle: textTheme.labelMedium?.copyWith(color: onSurface),
        side: BorderSide.none,
        shape: StadiumBorder(
          side: BorderSide(color: primary.withValues(alpha: 0.2)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: extension.buttonBorder,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: extension.buttonBorder,
          side: BorderSide(color: primary.withValues(alpha: 0.7)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: extension.surfaceVariant,
        hintStyle: textTheme.bodyMedium?.copyWith(color: extension.muted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: extension.muted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: extension.cardRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: extension.cardRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: extension.cardRadius,
          borderSide: BorderSide(color: primary, width: 1.4),
        ),
      ),
      extensions: [extension],
    );
  }

  static TextTheme _textTheme(TitleStyle style, Color color) {
    final base = ThemeData(
      brightness: Brightness.dark,
    ).textTheme.apply(bodyColor: color, displayColor: color);

    return switch (style) {
      TitleStyle.athletic => base.copyWith(
        displaySmall: base.displaySmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          height: 0.95,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
      TitleStyle.elegant => base.copyWith(
        displaySmall: base.displaySmall?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: -0.6,
          height: 1.05,
          fontStyle: FontStyle.italic,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      TitleStyle.modern => base.copyWith(
        displaySmall: base.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -1.2,
          height: 0.95,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
    };
  }
}
