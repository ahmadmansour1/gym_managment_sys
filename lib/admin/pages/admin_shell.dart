import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../presentation/widgets/branded_button.dart';
import '../state/admin_session.dart';
import 'dashboard_page.dart';
import 'members_page.dart';
import 'plans_admin_page.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AdminSession>();
    final gym = session.gym!;
    final staff = session.staff!;
    final wide = MediaQuery.sizeOf(context).width >= 980;

    final content = switch (session.section) {
      AdminSection.dashboard => const DashboardPage(),
      AdminSection.members => const MembersPage(),
      AdminSection.plans => const PlansAdminPage(),
    };

    if (!wide) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${gym.name} Admin'),
          actions: [
            IconButton(
              tooltip: 'Log out',
              onPressed: session.logout,
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: content,
        bottomNavigationBar: NavigationBar(
          selectedIndex: session.section.index,
          onDestinationSelected: (index) {
            session.setSection(AdminSection.values[index]);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.space_dashboard_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              label: 'Members',
            ),
            NavigationDestination(
              icon: Icon(Icons.card_membership_outlined),
              label: 'Plans',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 248,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                          context.brand.radius * 0.55,
                        ),
                      ),
                      child: Icon(
                        gymIcon(gym.icon),
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gym.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'Admin',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: context.brand.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _NavItem(
                  label: 'Dashboard',
                  icon: Icons.space_dashboard_outlined,
                  selected: session.section == AdminSection.dashboard,
                  onTap: () => session.setSection(AdminSection.dashboard),
                ),
                _NavItem(
                  label: 'Members',
                  icon: Icons.groups_outlined,
                  selected: session.section == AdminSection.members,
                  onTap: () => session.setSection(AdminSection.members),
                ),
                _NavItem(
                  label: 'Plans',
                  icon: Icons.card_membership_outlined,
                  selected: session.section == AdminSection.plans,
                  onTap: () => session.setSection(AdminSection.plans),
                ),
                const Spacer(),
                Text(staff.name, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  staff.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: context.brand.muted),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: session.logout,
                  child: const Text('Log out'),
                ),
              ],
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.14)
            : Colors.transparent,
        borderRadius: brand.cardRadius,
        child: InkWell(
          borderRadius: brand.cardRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? theme.colorScheme.primary : brand.muted,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
