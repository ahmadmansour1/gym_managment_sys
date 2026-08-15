class MembershipPlan {
  const MembershipPlan({
    required this.id,
    required this.gymId,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.durationMonths,
    required this.durationDays,
    required this.features,
    required this.isFeatured,
    required this.isPopular,
  });

  final String id;
  final String gymId;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int durationMonths;
  final int durationDays;
  final List<String> features;
  final bool isFeatured;
  final bool isPopular;

  String get priceLabel {
    final amount = price.truncateToDouble() == price
        ? price.toStringAsFixed(0)
        : price.toStringAsFixed(2);
    final symbol = currency == 'USD' ? '\$' : '$currency ';
    return '$symbol$amount';
  }

  String get periodLabel {
    if (durationMonths == 1) return '1 month';
    return '$durationMonths months';
  }

  String get monthlyEquivalentLabel {
    if (durationMonths <= 1) return priceLabel;
    final monthly = price / durationMonths;
    final amount = monthly.truncateToDouble() == monthly
        ? monthly.toStringAsFixed(0)
        : monthly.toStringAsFixed(0);
    return '\$$amount / mo';
  }
}
