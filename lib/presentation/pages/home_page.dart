import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/brand_theme.dart';
import '../state/session_controllers.dart';
import '../widgets/branded_button.dart';
import '../widgets/gym_brand_header.dart';
import '../widgets/my_membership_card.dart';
import 'plans_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();
    final gym = session.gym!;
    final member = session.member!;
    final live = session.subscription?.isLive ?? false;
    final heading = context.brand.titleStyle == TitleStyle.athletic
        ? 'MY MEMBERSHIP'
        : 'My membership';

    return Scaffold(
      appBar: AppBar(
        title: Text(gym.name),
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: session.logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          GymBrandHeader(gym: gym),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${member.firstName}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  member.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: context.brand.muted),
                ),
                const SizedBox(height: 24),
                Text(heading, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                MyMembershipCard(subscription: session.subscription),
                const SizedBox(height: 20),
                BrandedButton(
                  label: live ? 'Renew or change plan' : 'Subscribe',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PlansPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
