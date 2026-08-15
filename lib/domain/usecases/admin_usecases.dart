import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../entities/member.dart';
import '../entities/member_overview.dart';
import '../entities/membership_plan.dart';
import '../entities/staff.dart';
import '../entities/subscription.dart';
import '../repositories/admin_repository.dart';

class LoginAdmin {
  const LoginAdmin(this._repository);

  final AdminRepository _repository;

  Future<Result<Staff>> call({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      return Future.value(
        Result.err(const ValidationFailure('Email and password are required.')),
      );
    }
    return _repository.login(email: email.trim(), password: password);
  }
}

class LogoutAdmin {
  const LogoutAdmin(this._repository);

  final AdminRepository _repository;

  void call() => _repository.logout();
}

class GetDemoAdmins {
  const GetDemoAdmins(this._repository);

  final AdminRepository _repository;

  Future<Result<List<Staff>>> call() => _repository.demoAdmins();
}

class ListGymMembers {
  const ListGymMembers(this._repository);

  final AdminRepository _repository;

  Future<Result<List<MemberOverview>>> call() => _repository.listMembers();
}

class GetDashboardStats {
  const GetDashboardStats(this._repository);

  final AdminRepository _repository;

  Future<Result<DashboardStats>> call() => _repository.dashboardStats();
}

class AddGymMember {
  const AddGymMember(this._repository);

  final AdminRepository _repository;

  Future<Result<Member>> call({
    required String name,
    required String email,
    String password = '123456',
  }) {
    if (name.trim().isEmpty || email.trim().isEmpty) {
      return Future.value(
        Result.err(const ValidationFailure('Name and email are required.')),
      );
    }
    return _repository.addMember(name: name, email: email, password: password);
  }
}

class AssignMemberPlan {
  const AssignMemberPlan(this._repository);

  final AdminRepository _repository;

  Future<Result<Subscription>> call({
    required String memberId,
    required String planId,
  }) {
    return _repository.assignPlan(memberId: memberId, planId: planId);
  }
}

class CancelMemberPlan {
  const CancelMemberPlan(this._repository);

  final AdminRepository _repository;

  Future<Result<void>> call(String memberId) {
    return _repository.cancelMembership(memberId);
  }
}

class AddGymPlan {
  const AddGymPlan(this._repository);

  final AdminRepository _repository;

  Future<Result<MembershipPlan>> call({
    required String name,
    required String description,
    required double price,
    required int durationMonths,
  }) {
    if (name.trim().isEmpty || price <= 0) {
      return Future.value(
        Result.err(
          const ValidationFailure('Plan name and price are required.'),
        ),
      );
    }
    return _repository.addPlan(
      name: name,
      description: description,
      price: price,
      durationMonths: durationMonths,
    );
  }
}
