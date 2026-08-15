import 'package:flutter/material.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/member_overview.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final MemberPlanStatus status;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final (label, color) = switch (status) {
      MemberPlanStatus.active => ('Active', brand.success),
      MemberPlanStatus.expiring => ('Expiring', brand.accent),
      MemberPlanStatus.expired => ('Expired', theme.colorScheme.error),
      MemberPlanStatus.none => ('No plan', brand.muted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: brand.cardRadius,
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(brand.radius * 0.6),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: brand.muted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.headlineMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
