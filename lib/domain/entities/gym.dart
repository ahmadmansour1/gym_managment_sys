import 'brand_theme.dart';

class Gym {
  const Gym({
    required this.id,
    required this.name,
    required this.tagline,
    required this.city,
    required this.hours,
    required this.icon,
    required this.theme,
  });

  final String id;
  final String name;
  final String tagline;
  final String city;
  final String hours;
  final String icon;
  final BrandTheme theme;
}
