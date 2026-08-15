import 'member.dart';
import 'subscription.dart';

enum MemberPlanStatus { active, expiring, expired, none }

class MemberOverview {
  const MemberOverview({required this.member, this.subscription});

  final Member member;
  final Subscription? subscription;

  MemberPlanStatus get planStatus {
    final sub = subscription;
    if (sub == null) return MemberPlanStatus.none;
    if (!sub.isLive) return MemberPlanStatus.expired;
    if (sub.daysRemaining <= 7) return MemberPlanStatus.expiring;
    return MemberPlanStatus.active;
  }

  String get statusLabel => switch (planStatus) {
    MemberPlanStatus.active => 'Active',
    MemberPlanStatus.expiring => 'Expiring',
    MemberPlanStatus.expired => 'Expired',
    MemberPlanStatus.none => 'No plan',
  };
}

class DashboardStats {
  const DashboardStats({
    required this.totalMembers,
    required this.active,
    required this.expiringSoon,
    required this.expired,
    required this.noPlan,
  });

  final int totalMembers;
  final int active;
  final int expiringSoon;
  final int expired;
  final int noPlan;
}
