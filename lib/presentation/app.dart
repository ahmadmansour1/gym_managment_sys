import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/app_container.dart';
import '../../core/theme/theme_factory.dart';
import '../../domain/entities/gym.dart';
import '../../domain/entities/member.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'state/session_controllers.dart';

class GymApp extends StatelessWidget {
  const GymApp({super.key, required this.container});

  final AppContainer container;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppSession(
        getCurrentGym: container.getCurrentGym,
        loginMember: container.loginMember,
        logoutMember: container.logoutMember,
        getDemoMembers: container.getDemoMembers,
        getMembershipPlans: container.getMembershipPlans,
        getMemberSubscription: container.getMemberSubscription,
        subscribeToPlan: container.subscribeToPlan,
      )..bootstrap(),
      child: const _ThemedApp(),
    );
  }
}

class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    final gym = context.select<AppSession, Gym?>((session) => session.gym);
    final bootstrapping = context.select<AppSession, bool>(
      (session) => session.isBootstrapping,
    );

    return MaterialApp(
      title: gym?.name ?? 'Gym',
      debugShowCheckedModeBanner: false,
      theme: gym == null
          ? ThemeFactory.platform()
          : ThemeFactory.fromBrand(gym.theme),
      home: bootstrapping ? const _LaunchScreen() : const _AuthGate(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final member = context.select<AppSession, Member?>(
      (session) => session.member,
    );
    if (member == null) return const LoginPage();
    return const HomePage();
  }
}

class _LaunchScreen extends StatelessWidget {
  const _LaunchScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
