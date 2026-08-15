import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/di/app_container.dart';
import '../core/theme/theme_factory.dart';
import '../domain/entities/gym.dart';
import '../domain/entities/staff.dart';
import 'pages/admin_login_page.dart';
import 'pages/admin_shell.dart';
import 'state/admin_session.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key, required this.container});

  final AppContainer container;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminSession(
        getCurrentGym: container.getCurrentGym,
        getMembershipPlans: container.getMembershipPlans,
        loginAdmin: container.loginAdmin,
        logoutAdmin: container.logoutAdmin,
        getDemoAdmins: container.getDemoAdmins,
        listGymMembers: container.listGymMembers,
        getDashboardStats: container.getDashboardStats,
        addGymMember: container.addGymMember,
        assignMemberPlan: container.assignMemberPlan,
        cancelMemberPlan: container.cancelMemberPlan,
        addGymPlan: container.addGymPlan,
      )..bootstrap(),
      child: const _ThemedAdminApp(),
    );
  }
}

class _ThemedAdminApp extends StatelessWidget {
  const _ThemedAdminApp();

  @override
  Widget build(BuildContext context) {
    final gym = context.select<AdminSession, Gym?>((session) => session.gym);
    final bootstrapping = context.select<AdminSession, bool>(
      (session) => session.isBootstrapping,
    );

    return MaterialApp(
      title: gym == null ? 'Gym Admin' : '${gym.name} Admin',
      debugShowCheckedModeBanner: false,
      theme: gym == null
          ? ThemeFactory.platform()
          : ThemeFactory.fromBrand(gym.theme),
      home: bootstrapping
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : const _AdminGate(),
    );
  }
}

class _AdminGate extends StatelessWidget {
  const _AdminGate();

  @override
  Widget build(BuildContext context) {
    final staff = context.select<AdminSession, Staff?>(
      (session) => session.staff,
    );
    if (staff == null) return const AdminLoginPage();
    return const AdminShell();
  }
}
