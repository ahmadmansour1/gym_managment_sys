import 'package:flutter/material.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/gym.dart';
import 'branded_button.dart';

class GymBrandHeader extends StatelessWidget {
  const GymBrandHeader({super.key, required this.gym});

  final Gym gym;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.22),
            brand.surfaceVariant,
            theme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(brand.radius * 0.7),
            ),
            child: Icon(gymIcon(gym.icon), color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 18),
          Text(
            gym.name,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gym.tagline,
            style: theme.textTheme.titleMedium?.copyWith(
              color: brand.muted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(icon: Icons.location_on_outlined, label: gym.city),
              _MetaChip(icon: Icons.schedule_outlined, label: gym.hours),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(brand.radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: brand.accent),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
