import '../../core/utils/result.dart';
import '../entities/member.dart';
import '../entities/member_overview.dart';
import '../entities/membership_plan.dart';
import '../entities/staff.dart';
import '../entities/subscription.dart';

abstract class AdminRepository {
  Staff? get currentStaff;

  Future<Result<Staff>> login({
    required String email,
    required String password,
  });

  void logout();

  Future<Result<List<Staff>>> demoAdmins();

  Future<Result<List<MemberOverview>>> listMembers();

  Future<Result<DashboardStats>> dashboardStats();

  Future<Result<Member>> addMember({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<Subscription>> assignPlan({
    required String memberId,
    required String planId,
  });

  Future<Result<void>> cancelMembership(String memberId);

  Future<Result<MembershipPlan>> addPlan({
    required String name,
    required String description,
    required double price,
    required int durationMonths,
  });
}
