import 'package:flutter/material.dart';

import '../../core/theme/theme_factory.dart';
import '../../domain/entities/gym.dart';
import '../../domain/entities/member_overview.dart';
import '../../domain/entities/membership_plan.dart';
import '../../domain/entities/staff.dart';
import '../../domain/usecases/admin_usecases.dart';
import '../../domain/usecases/get_current_gym.dart';
import '../../domain/usecases/membership_usecases.dart';

enum AdminSection { dashboard, members, plans }

class AdminSession extends ChangeNotifier {
  AdminSession({
    required GetCurrentGym getCurrentGym,
    required GetMembershipPlans getMembershipPlans,
    required LoginAdmin loginAdmin,
    required LogoutAdmin logoutAdmin,
    required GetDemoAdmins getDemoAdmins,
    required ListGymMembers listGymMembers,
    required GetDashboardStats getDashboardStats,
    required AddGymMember addGymMember,
    required AssignMemberPlan assignMemberPlan,
    required CancelMemberPlan cancelMemberPlan,
    required AddGymPlan addGymPlan,
  }) : _getCurrentGym = getCurrentGym,
       _getMembershipPlans = getMembershipPlans,
       _loginAdmin = loginAdmin,
       _logoutAdmin = logoutAdmin,
       _getDemoAdmins = getDemoAdmins,
       _listGymMembers = listGymMembers,
       _getDashboardStats = getDashboardStats,
       _addGymMember = addGymMember,
       _assignMemberPlan = assignMemberPlan,
       _cancelMemberPlan = cancelMemberPlan,
       _addGymPlan = addGymPlan;

  final GetCurrentGym _getCurrentGym;
  final GetMembershipPlans _getMembershipPlans;
  final LoginAdmin _loginAdmin;
  final LogoutAdmin _logoutAdmin;
  final GetDemoAdmins _getDemoAdmins;
  final ListGymMembers _listGymMembers;
  final GetDashboardStats _getDashboardStats;
  final AddGymMember _addGymMember;
  final AssignMemberPlan _assignMemberPlan;
  final CancelMemberPlan _cancelMemberPlan;
  final AddGymPlan _addGymPlan;

  Gym? gym;
  Staff? staff;
  List<Staff> demoAdmins = const [];
  List<MembershipPlan> plans = const [];
  List<MemberOverview> members = const [];
  DashboardStats stats = const DashboardStats(
    totalMembers: 0,
    active: 0,
    expiringSoon: 0,
    expired: 0,
    noPlan: 0,
  );
  AdminSection section = AdminSection.dashboard;
  bool isBootstrapping = true;
  bool isAuthenticating = false;
  bool isSaving = false;
  String? errorMessage;
  String searchQuery = '';

  bool get isLoggedIn => staff != null;

  List<MemberOverview> get filteredMembers {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return members;
    return members.where((row) {
      return row.member.name.toLowerCase().contains(query) ||
          row.member.email.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> bootstrap() async {
    isBootstrapping = true;
    errorMessage = null;
    notifyListeners();

    final gymResult = await _getCurrentGym();
    if (!gymResult.isOk) {
      errorMessage = gymResult.failure?.message ?? 'Could not load gym.';
      isBootstrapping = false;
      notifyListeners();
      return;
    }
    gym = gymResult.data;

    final plansResult = await _getMembershipPlans();
    if (plansResult.isOk) plans = plansResult.data ?? const [];

    final adminsResult = await _getDemoAdmins();
    if (adminsResult.isOk) demoAdmins = adminsResult.data ?? const [];

    isBootstrapping = false;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    isAuthenticating = true;
    errorMessage = null;
    notifyListeners();

    final result = await _loginAdmin(email: email, password: password);
    if (!result.isOk) {
      errorMessage = result.failure?.message ?? 'Sign in failed.';
      isAuthenticating = false;
      notifyListeners();
      return false;
    }

    staff = result.data;
    isAuthenticating = false;
    await refresh();
    return true;
  }

  void logout() {
    _logoutAdmin();
    staff = null;
    members = const [];
    section = AdminSection.dashboard;
    errorMessage = null;
    notifyListeners();
  }

  void setSection(AdminSection value) {
    section = value;
    notifyListeners();
  }

  void setSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  Future<void> refresh() async {
    final statsResult = await _getDashboardStats();
    if (statsResult.isOk && statsResult.data != null) {
      stats = statsResult.data!;
    }
    final membersResult = await _listGymMembers();
    if (membersResult.isOk) {
      members = membersResult.data ?? const [];
    }
    final plansResult = await _getMembershipPlans();
    if (plansResult.isOk) {
      plans = plansResult.data ?? const [];
    }
    notifyListeners();
  }

  Future<String?> addMember({
    required String name,
    required String email,
  }) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    final result = await _addGymMember(name: name, email: email);
    isSaving = false;
    if (!result.isOk) {
      errorMessage = result.failure?.message;
      notifyListeners();
      return errorMessage;
    }
    await refresh();
    return null;
  }

  Future<String?> assignPlan({
    required String memberId,
    required String planId,
  }) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    final result = await _assignMemberPlan(memberId: memberId, planId: planId);
    isSaving = false;
    if (!result.isOk) {
      errorMessage = result.failure?.message;
      notifyListeners();
      return errorMessage;
    }
    await refresh();
    return null;
  }

  Future<String?> cancelPlan(String memberId) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    final result = await _cancelMemberPlan(memberId);
    isSaving = false;
    if (!result.isOk) {
      errorMessage = result.failure?.message;
      notifyListeners();
      return errorMessage;
    }
    await refresh();
    return null;
  }

  Future<String?> addPlan({
    required String name,
    required String description,
    required double price,
    required int durationMonths,
  }) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    final result = await _addGymPlan(
      name: name,
      description: description,
      price: price,
      durationMonths: durationMonths,
    );
    isSaving = false;
    if (!result.isOk) {
      errorMessage = result.failure?.message;
      notifyListeners();
      return errorMessage;
    }
    await refresh();
    return null;
  }

  ThemeData get themeData {
    final current = gym;
    if (current == null) return ThemeFactory.platform();
    return ThemeFactory.fromBrand(current.theme);
  }
}
