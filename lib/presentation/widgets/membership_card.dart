import 'package:flutter/material.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/brand_theme.dart';
import '../../domain/entities/membership_plan.dart';

class MembershipCard extends StatelessWidget {
  const MembershipCard({
    super.key,
    required this.plan,
    required this.onTap,
    this.isActive = false,
  });

  final MembershipPlan plan;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    final featured = plan.isFeatured;

    return Material(
      color: featured ? theme.colorScheme.surface : brand.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: brand.cardRadius,
        side: featured
            ? BorderSide(color: theme.colorScheme.primary, width: 1.6)
            : brand.cardStyle == CardStyle.outlined
            ? BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.25),
              )
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _title(context, plan.name),
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  if (plan.isPopular)
                    _Badge(
                      label: 'Popular',
                      color: brand.accent,
                      onColor: theme.colorScheme.onSurface,
                    ),
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    _Badge(
                      label: 'Active',
                      color: brand.success,
                      onColor: Colors.white,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                plan.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: brand.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.priceLabel,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '/ ${plan.periodLabel}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brand.muted,
                      ),
                    ),
                  ),
                  if (plan.durationMonths > 1) ...[
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        plan.monthlyEquivalentLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: brand.accent,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              ...plan.features
                  .take(3)
                  .map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: brand.success,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              if (plan.features.length > 3)
                Text(
                  '+${plan.features.length - 3} more',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
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

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.onColor,
  });

  final String label;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
