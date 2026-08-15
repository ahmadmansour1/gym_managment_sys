import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../core/utils/date_format.dart';
import '../../domain/entities/member_overview.dart';
import '../state/admin_session.dart';
import '../widgets/admin_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AdminSession>();
    final stats = session.stats;
    final gym = session.gym!;
    final recent = session.members.take(6).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 40),
      children: [
        Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Members and memberships for ${gym.name} only.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: context.brand.muted),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _Stat(
              StatCard(
                label: 'Members',
                value: '${stats.totalMembers}',
                icon: Icons.groups_rounded,
              ),
            ),
            _Stat(
              StatCard(
                label: 'Active',
                value: '${stats.active}',
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
            _Stat(
              StatCard(
                label: 'Expiring (7 days)',
                value: '${stats.expiringSoon}',
                icon: Icons.schedule_rounded,
              ),
            ),
            _Stat(
              StatCard(
                label: 'Expired / none',
                value: '${stats.expired + stats.noPlan}',
                icon: Icons.person_off_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text('Members', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        _MembersPreview(rows: recent),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 240, child: child);
  }
}

class _MembersPreview extends StatelessWidget {
  const _MembersPreview({required this.rows});

  final List<MemberOverview> rows;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: brand.cardRadius,
      ),
      child: Column(
        children: rows.map((row) {
          final sub = row.subscription;
          return ListTile(
            title: Text(row.member.name),
            subtitle: Text(
              sub == null
                  ? 'No membership'
                  : '${sub.planName} · expires ${formatDisplayDate(sub.expiresAt)}',
            ),
            trailing: StatusBadge(status: row.planStatus),
          );
        }).toList(),
      ),
    );
  }
}
