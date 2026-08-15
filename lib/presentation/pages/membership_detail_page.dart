import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/brand_theme.dart';
import '../../domain/entities/membership_plan.dart';
import '../state/session_controllers.dart';
import '../widgets/branded_button.dart';
import 'subscribe_success_page.dart';

class MembershipDetailPage extends StatelessWidget {
  const MembershipDetailPage({super.key, required this.plan});

  final MembershipPlan plan;

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();
    final brand = context.brand;
    final theme = Theme.of(context);
    final current = session.subscription;
    final alreadyThisPlan =
        current?.isLive == true && current?.planId == plan.id;

    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 32),
        children: [
          Text(_title(context, plan.name), style: theme.textTheme.displaySmall),
          const SizedBox(height: 10),
          Text(
            plan.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: brand.muted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: brand.cardRadius,
            ),
            child: Row(
              children: [
                Text(
                  plan.priceLabel,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/ ${plan.periodLabel}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: brand.muted,
                  ),
                ),
                const Spacer(),
                Text(
                  plan.monthlyEquivalentLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: brand.accent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            context.brand.titleStyle == TitleStyle.athletic
                ? 'WHAT YOU GET'
                : 'What you get',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...plan.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, color: brand.success),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(feature, style: theme.textTheme.bodyLarge),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (session.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                session.errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          BrandedButton(
            label: alreadyThisPlan ? 'Currently active' : 'Subscribe',
            loading: session.isSubscribing,
            onPressed: alreadyThisPlan
                ? null
                : () async {
                    final booking = await session.subscribe(plan.id);
                    if (booking == null || !context.mounted) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            SubscribeSuccessPage(subscription: booking),
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }

  String _title(BuildContext context, String value) {
    if (context.brand.titleStyle == TitleStyle.athletic) {
      return value.toUpperCase();
    }
    return value;
  }
}
