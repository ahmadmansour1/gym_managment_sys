import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../core/utils/date_format.dart';
import '../../domain/entities/member_overview.dart';
import '../../domain/entities/membership_plan.dart';
import '../../presentation/widgets/branded_button.dart';
import '../state/admin_session.dart';
import '../widgets/admin_widgets.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AdminSession>();
    final rows = session.filteredMembers;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Members',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              FilledButton.icon(
                onPressed: () => showAddMemberDialog(context),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Add member'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Assign or cancel memberships. Members will see the same dates in the gym app.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.brand.muted),
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: session.setSearch,
            decoration: const InputDecoration(
              hintText: 'Search name or email',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: context.brand.cardRadius,
              ),
              child: rows.isEmpty
                  ? Center(
                      child: Text(
                        'No members match.',
                        style: TextStyle(color: context.brand.muted),
                      ),
                    )
                  : ListView.separated(
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: context.brand.muted.withValues(alpha: 0.2),
                      ),
                      itemBuilder: (context, index) {
                        return _MemberTile(row: rows[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.row});

  final MemberOverview row;

  @override
  Widget build(BuildContext context) {
    final sub = row.subscription;
    final live = sub?.isLive ?? false;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(row.member.name),
      subtitle: Text(
        [
          row.member.email,
          if (sub != null)
            '${sub.planName} · ${formatDisplayDate(sub.startsAt)} → ${formatDisplayDate(sub.expiresAt)}',
          if (sub == null) 'No membership assigned',
        ].join('\n'),
      ),
      isThreeLine: true,
      trailing: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          StatusBadge(status: row.planStatus),
          TextButton(
            onPressed: () => showAssignPlanDialog(context, row),
            child: Text(live ? 'Change' : 'Assign'),
          ),
          if (live)
            TextButton(
              onPressed: () async {
                final error = await context.read<AdminSession>().cancelPlan(
                  row.member.id,
                );
                if (error != null && context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showAddMemberDialog(BuildContext context) async {
  final name = TextEditingController();
  final email = TextEditingController();
  final session = context.read<AdminSession>();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Add member'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Full name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              Text(
                'Mock password will be 123456. Later this is a Firebase Auth user under this gym.',
                style: Theme.of(dialogContext).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () async {
              final error = await session.addMember(
                name: name.text,
                email: email.text,
              );
              if (!dialogContext.mounted) return;
              if (error != null) {
                ScaffoldMessenger.of(
                  dialogContext,
                ).showSnackBar(SnackBar(content: Text(error)));
                return;
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  name.dispose();
  email.dispose();
}

Future<void> showAssignPlanDialog(
  BuildContext context,
  MemberOverview row,
) async {
  final session = context.read<AdminSession>();
  MembershipPlan? selected = session.plans.isEmpty ? null : session.plans.first;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Assign plan · ${row.member.name}'),
            content: SizedBox(
              width: 420,
              child: DropdownButtonFormField<MembershipPlan>(
                initialValue: selected,
                items: session.plans
                    .map(
                      (plan) => DropdownMenuItem(
                        value: plan,
                        child: Text(
                          '${plan.name} · ${plan.priceLabel} / ${plan.periodLabel}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => selected = value),
                decoration: const InputDecoration(labelText: 'Membership'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Close'),
              ),
              BrandedButton(
                expand: false,
                label: 'Assign',
                onPressed: selected == null
                    ? null
                    : () async {
                        final error = await session.assignPlan(
                          memberId: row.member.id,
                          planId: selected!.id,
                        );
                        if (!dialogContext.mounted) return;
                        if (error != null) {
                          ScaffoldMessenger.of(
                            dialogContext,
                          ).showSnackBar(SnackBar(content: Text(error)));
                          return;
                        }
                        Navigator.pop(dialogContext);
                      },
              ),
            ],
          );
        },
      );
    },
  );
}
