import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../core/utils/date_format.dart';
import '../../domain/entities/subscription.dart';
import '../state/session_controllers.dart';
import '../widgets/branded_button.dart';

class SubscribeSuccessPage extends StatelessWidget {
  const SubscribeSuccessPage({super.key, required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final gym = context.watch<AppSession>().gym!;
    final brand = context.brand;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: brand.success.withValues(alpha: 0.18),
                  borderRadius: brand.cardRadius,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: brand.success,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text('Membership updated', style: theme.textTheme.displaySmall),
              const SizedBox(height: 10),
              Text(
                '${subscription.planName} at ${gym.name} starts ${formatDisplayDate(subscription.startsAt)} and expires ${formatDisplayDate(subscription.expiresAt)}.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: brand.muted,
                  height: 1.45,
                ),
              ),
              const Spacer(),
              BrandedButton(
                label: 'Back to my membership',
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
