enum ThemeBrightness { light, dark }

enum ButtonShape { pill, rounded, square }

enum CardStyle { filled, elevated, outlined }

enum TitleStyle { athletic, elegant, modern }

class BrandTheme {
  const BrandTheme({
    required this.brightness,
    required this.primaryHex,
    required this.secondaryHex,
    required this.accentHex,
    required this.backgroundHex,
    required this.surfaceHex,
    required this.surfaceVariantHex,
    required this.onPrimaryHex,
    required this.onBackgroundHex,
    required this.onSurfaceHex,
    required this.mutedHex,
    required this.successHex,
    required this.errorHex,
    required this.borderRadius,
    required this.buttonShape,
    required this.cardStyle,
    required this.titleStyle,
  });

  final ThemeBrightness brightness;
  final String primaryHex;
  final String secondaryHex;
  final String accentHex;
  final String backgroundHex;
  final String surfaceHex;
  final String surfaceVariantHex;
  final String onPrimaryHex;
  final String onBackgroundHex;
  final String onSurfaceHex;
  final String mutedHex;
  final String successHex;
  final String errorHex;
  final double borderRadius;
  final ButtonShape buttonShape;
  final CardStyle cardStyle;
  final TitleStyle titleStyle;
}
