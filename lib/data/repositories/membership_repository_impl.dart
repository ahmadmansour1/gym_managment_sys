import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/membership_plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/membership_repository.dart';
import '../datasources/tenant_local_datasource.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  MembershipRepositoryImpl(this._dataSource);

  final TenantLocalDataSource _dataSource;

  @override
  Future<Result<List<MembershipPlan>>> getPlans() async {
    try {
      final snapshot = await _dataSource.loadTenant();
      return Result.ok(snapshot.plans);
    } catch (error) {
      return Result.err(Failure('Could not load plans: $error'));
    }
  }

  @override
  Future<Result<Subscription?>> getMemberSubscription(String memberId) async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final match = snapshot.subscriptions.where(
        (item) => item.memberId == memberId,
      );
      if (match.isEmpty) return Result.ok(null);
      return Result.ok(match.last);
    } catch (error) {
      return Result.err(Failure('Could not load membership: $error'));
    }
  }

  @override
  Future<Result<Subscription>> subscribe({
    required String memberId,
    required String planId,
  }) async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final planMatch = snapshot.plans.where((plan) => plan.id == planId);
      if (planMatch.isEmpty) {
        return Result.err(NotFoundFailure('Plan "$planId" was not found.'));
      }
      final plan = planMatch.first;
      final now = DateTime.now();
      final startsAt = DateTime(now.year, now.month, now.day);
      final subscription = Subscription(
        id: 'sub-$memberId-${now.millisecondsSinceEpoch}',
        gymId: snapshot.gym.id,
        memberId: memberId,
        planId: plan.id,
        planName: plan.name,
        startsAt: startsAt,
        expiresAt: startsAt.add(Duration(days: plan.durationDays)),
        status: SubscriptionStatus.active,
      );
      _dataSource.upsertSubscription(subscription);
      return Result.ok(subscription);
    } catch (error) {
      return Result.err(Failure('Could not subscribe: $error'));
    }
  }
}
