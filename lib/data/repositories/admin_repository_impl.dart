import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/member_overview.dart';
import '../../domain/entities/membership_plan.dart';
import '../../domain/entities/staff.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/tenant_local_datasource.dart';
import '../models/tenant_models.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._dataSource);

  final TenantLocalDataSource _dataSource;
  Staff? _currentStaff;

  @override
  Staff? get currentStaff => _currentStaff;

  @override
  Future<Result<Staff>> login({
    required String email,
    required String password,
  }) async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final match = snapshot.admins.where(
        (account) =>
            account.entity.email.toLowerCase() == email.toLowerCase() &&
            account.password == password,
      );
      if (match.isEmpty) {
        return Result.err(
          const AuthFailure('No admin found with those details at this gym.'),
        );
      }
      _currentStaff = match.first.entity;
      return Result.ok(_currentStaff!);
    } catch (error) {
      return Result.err(Failure('Could not sign in: $error'));
    }
  }

  @override
  void logout() {
    _currentStaff = null;
  }

  @override
  Future<Result<List<Staff>>> demoAdmins() async {
    try {
      final snapshot = await _dataSource.loadTenant();
      return Result.ok(snapshot.admins.map((item) => item.entity).toList());
    } catch (error) {
      return Result.err(Failure('Could not load admins: $error'));
    }
  }

  @override
  Future<Result<List<MemberOverview>>> listMembers() async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final overviews = snapshot.members.map((account) {
        final subs = snapshot.subscriptions.where(
          (item) => item.memberId == account.entity.id,
        );
        return MemberOverview(
          member: account.entity,
          subscription: subs.isEmpty ? null : subs.last,
        );
      }).toList();
      return Result.ok(overviews);
    } catch (error) {
      return Result.err(Failure('Could not load members: $error'));
    }
  }

  @override
  Future<Result<DashboardStats>> dashboardStats() async {
    final members = await listMembers();
    if (!members.isOk) return Result.err(members.failure!);
    final rows = members.data!;
    return Result.ok(
      DashboardStats(
        totalMembers: rows.length,
        active: rows
            .where((row) => row.planStatus == MemberPlanStatus.active)
            .length,
        expiringSoon: rows
            .where((row) => row.planStatus == MemberPlanStatus.expiring)
            .length,
        expired: rows
            .where((row) => row.planStatus == MemberPlanStatus.expired)
            .length,
        noPlan: rows
            .where((row) => row.planStatus == MemberPlanStatus.none)
            .length,
      ),
    );
  }

  @override
  Future<Result<Member>> addMember({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final exists = snapshot.members.any(
        (item) => item.entity.email.toLowerCase() == email.toLowerCase(),
      );
      if (exists) {
        return Result.err(
          const ValidationFailure('A member with that email already exists.'),
        );
      }
      final now = DateTime.now().millisecondsSinceEpoch;
      final member = Member(
        id: 'member-$now',
        gymId: snapshot.gym.id,
        name: name.trim(),
        email: email.trim().toLowerCase(),
      );
      _dataSource.addMember(MemberModel(entity: member, password: password));
      return Result.ok(member);
    } catch (error) {
      return Result.err(Failure('Could not add member: $error'));
    }
  }

  @override
  Future<Result<Subscription>> assignPlan({
    required String memberId,
    required String planId,
  }) async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final member = _dataSource.memberById(memberId);
      if (member == null) {
        return Result.err(const NotFoundFailure('Member was not found.'));
      }
      final planMatch = snapshot.plans.where((plan) => plan.id == planId);
      if (planMatch.isEmpty) {
        return Result.err(NotFoundFailure('Plan "$planId" was not found.'));
      }
      final plan = planMatch.first;
      final now = DateTime.now();
      final startsAt = DateTime(now.year, now.month, now.day);
      final subscription = Subscription(
        id: 'sub-$memberId-$now',
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
      return Result.err(Failure('Could not assign plan: $error'));
    }
  }

  @override
  Future<Result<void>> cancelMembership(String memberId) async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final match = snapshot.subscriptions.where(
        (item) => item.memberId == memberId,
      );
      if (match.isEmpty) {
        return Result.err(
          const NotFoundFailure('This member has no membership to cancel.'),
        );
      }
      final current = match.last;
      final today = DateTime.now();
      final cancelled = Subscription(
        id: current.id,
        gymId: current.gymId,
        memberId: current.memberId,
        planId: current.planId,
        planName: current.planName,
        startsAt: current.startsAt,
        expiresAt: DateTime(today.year, today.month, today.day),
        status: SubscriptionStatus.expired,
      );
      _dataSource.upsertSubscription(cancelled);
      return Result.ok(null);
    } catch (error) {
      return Result.err(Failure('Could not cancel membership: $error'));
    }
  }

  @override
  Future<Result<MembershipPlan>> addPlan({
    required String name,
    required String description,
    required double price,
    required int durationMonths,
  }) async {
    try {
      final snapshot = await _dataSource.loadTenant();
      final days = switch (durationMonths) {
        1 => 30,
        3 => 90,
        6 => 180,
        12 => 365,
        _ => durationMonths * 30,
      };
      final plan = MembershipPlan(
        id: 'plan-${DateTime.now().millisecondsSinceEpoch}',
        gymId: snapshot.gym.id,
        name: name.trim(),
        description: description.trim(),
        price: price,
        currency: 'USD',
        durationMonths: durationMonths,
        durationDays: days,
        features: const ['Unlimited gym access'],
        isFeatured: false,
        isPopular: false,
      );
      _dataSource.addPlan(plan);
      return Result.ok(plan);
    } catch (error) {
      return Result.err(Failure('Could not add plan: $error'));
    }
  }
}
