import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../entities/membership_plan.dart';
import '../entities/subscription.dart';
import '../repositories/membership_repository.dart';

class GetMembershipPlans {
  const GetMembershipPlans(this._repository);

  final MembershipRepository _repository;

  Future<Result<List<MembershipPlan>>> call() => _repository.getPlans();
}

class GetMemberSubscription {
  const GetMemberSubscription(this._repository);

  final MembershipRepository _repository;

  Future<Result<Subscription?>> call(String memberId) {
    return _repository.getMemberSubscription(memberId);
  }
}

class SubscribeToPlan {
  const SubscribeToPlan(this._repository);

  final MembershipRepository _repository;

  Future<Result<Subscription>> call({
    required String memberId,
    required String planId,
  }) {
    if (memberId.isEmpty || planId.isEmpty) {
      return Future.value(
        Result.err(const ValidationFailure('Member and plan are required.')),
      );
    }
    return _repository.subscribe(memberId: memberId, planId: planId);
  }
}
