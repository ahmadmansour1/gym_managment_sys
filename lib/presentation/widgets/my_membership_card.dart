import 'package:flutter/material.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../core/utils/date_format.dart';
import '../../domain/entities/subscription.dart';

class MyMembershipCard extends StatelessWidget {
  const MyMembershipCard({super.key, required this.subscription});

  final Subscription? subscription;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final sub = subscription;

    if (sub == null) {
      return _Shell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No membership yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Choose 1, 3, 6, or 12 months to start training at this gym.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: brand.muted,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    final live = sub.isLive;
    final days = sub.daysRemaining;
    final statusColor = live ? brand.success : theme.colorScheme.error;
    final statusLabel = live ? 'Active' : 'Expired';
    final daysLabel = live
        ? (days == 0 ? 'Expires today' : '$days days left')
        : 'Ended ${formatDisplayDate(sub.expiresAt)}';

    return _Shell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(sub.planName, style: theme.textTheme.titleLarge),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _DateRow(label: 'Starts', value: formatDisplayDate(sub.startsAt)),
          const SizedBox(height: 10),
          _DateRow(label: 'Expires', value: formatDisplayDate(sub.expiresAt)),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: live ? sub.elapsedFraction : 1,
              minHeight: 8,
              backgroundColor: brand.muted.withValues(alpha: 0.2),
              color: live ? theme.colorScheme.primary : theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            daysLabel,
            style: theme.textTheme.labelLarge?.copyWith(color: brand.muted),
          ),
        ],
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.brand.cardRadius,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: child,
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.brand.muted),
          ),
        ),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
