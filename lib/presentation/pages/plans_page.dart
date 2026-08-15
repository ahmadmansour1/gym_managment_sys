import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/brand_theme.dart';
import '../state/session_controllers.dart';
import '../widgets/membership_card.dart';
import 'membership_detail_page.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();
    final activeId = session.subscription?.isLive == true
        ? session.subscription?.planId
        : null;
    final heading = context.brand.titleStyle == TitleStyle.athletic
        ? 'PLANS'
        : 'Plans';

    return Scaffold(
      appBar: AppBar(title: Text(heading)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Subscribe for 1, 3, 6, or 12 months. Dates start today and you will see the new expiry on your membership.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.brand.muted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          ...session.plans.map(
            (plan) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: MembershipCard(
                plan: plan,
                isActive: activeId == plan.id,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => MembershipDetailPage(plan: plan),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
