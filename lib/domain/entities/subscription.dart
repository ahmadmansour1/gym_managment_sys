enum SubscriptionStatus { active, expired }

class Subscription {
  const Subscription({
    required this.id,
    required this.gymId,
    required this.memberId,
    required this.planId,
    required this.planName,
    required this.startsAt,
    required this.expiresAt,
    required this.status,
  });

  final String id;
  final String gymId;
  final String memberId;
  final String planId;
  final String planName;
  final DateTime startsAt;
  final DateTime expiresAt;
  final SubscriptionStatus status;

  bool get isLive {
    final today = DateTime.now();
    final end = DateTime(
      expiresAt.year,
      expiresAt.month,
      expiresAt.day,
      23,
      59,
    );
    return status == SubscriptionStatus.active && !today.isAfter(end);
  }

  int get daysRemaining {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final end = DateTime(expiresAt.year, expiresAt.month, expiresAt.day);
    return end.difference(today).inDays;
  }

  double get elapsedFraction {
    final total = expiresAt.difference(startsAt).inDays;
    if (total <= 0) return 1;
    final used = total - daysRemaining;
    return (used / total).clamp(0, 1);
  }
}
