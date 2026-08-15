import '../../core/utils/result.dart';
import '../entities/membership_plan.dart';
import '../entities/subscription.dart';

abstract class MembershipRepository {
  Future<Result<List<MembershipPlan>>> getPlans();

  Future<Result<Subscription?>> getMemberSubscription(String memberId);

  Future<Result<Subscription>> subscribe({
    required String memberId,
    required String planId,
  });
}
