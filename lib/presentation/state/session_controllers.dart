import 'package:flutter/material.dart';

import '../../core/theme/theme_factory.dart';
import '../../domain/entities/gym.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/membership_plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/usecases/get_current_gym.dart';
import '../../domain/usecases/login_member.dart';
import '../../domain/usecases/membership_usecases.dart';

class AppSession extends ChangeNotifier {
  AppSession({
    required GetCurrentGym getCurrentGym,
    required LoginMember loginMember,
    required LogoutMember logoutMember,
    required GetDemoMembers getDemoMembers,
    required GetMembershipPlans getMembershipPlans,
    required GetMemberSubscription getMemberSubscription,
    required SubscribeToPlan subscribeToPlan,
  }) : _getCurrentGym = getCurrentGym,
       _loginMember = loginMember,
       _logoutMember = logoutMember,
       _getDemoMembers = getDemoMembers,
       _getMembershipPlans = getMembershipPlans,
       _getMemberSubscription = getMemberSubscription,
       _subscribeToPlan = subscribeToPlan;

  final GetCurrentGym _getCurrentGym;
  final LoginMember _loginMember;
  final LogoutMember _logoutMember;
  final GetDemoMembers _getDemoMembers;
  final GetMembershipPlans _getMembershipPlans;
  final GetMemberSubscription _getMemberSubscription;
  final SubscribeToPlan _subscribeToPlan;

  Gym? gym;
  Member? member;
  Subscription? subscription;
  List<MembershipPlan> plans = const [];
  List<Member> demoMembers = const [];
  bool isBootstrapping = true;
  bool isAuthenticating = false;
  bool isSubscribing = false;
  String? errorMessage;

  bool get isLoggedIn => member != null;

  ThemeData get themeData {
    final currentGym = gym;
    if (currentGym == null) return ThemeFactory.platform();
    return ThemeFactory.fromBrand(currentGym.theme);
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
    if (plansResult.isOk) {
      plans = plansResult.data!;
    }

    final membersResult = await _getDemoMembers();
    if (membersResult.isOk) {
      demoMembers = membersResult.data!;
    }

    isBootstrapping = false;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    isAuthenticating = true;
    errorMessage = null;
    notifyListeners();

    final result = await _loginMember(email: email, password: password);
    if (!result.isOk) {
      errorMessage = result.failure?.message ?? 'Sign in failed.';
      isAuthenticating = false;
      notifyListeners();
      return false;
    }

    member = result.data;
    final subResult = await _getMemberSubscription(member!.id);
    subscription = subResult.isOk ? subResult.data : null;
    isAuthenticating = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _logoutMember();
    member = null;
    subscription = null;
    errorMessage = null;
    notifyListeners();
  }

  Future<Subscription?> subscribe(String planId) async {
    final currentMember = member;
    if (currentMember == null) return null;

    isSubscribing = true;
    errorMessage = null;
    notifyListeners();

    final result = await _subscribeToPlan(
      memberId: currentMember.id,
      planId: planId,
    );
    isSubscribing = false;

    if (!result.isOk) {
      errorMessage = result.failure?.message ?? 'Could not subscribe.';
      notifyListeners();
      return null;
    }

    subscription = result.data;
    notifyListeners();
    return result.data;
  }
}
