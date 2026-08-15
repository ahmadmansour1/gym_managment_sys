import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/brand_theme.dart';
import '../state/admin_session.dart';
import '../../presentation/widgets/branded_button.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await context.read<AdminSession>().login(
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AdminSession>();
    final gym = session.gym;
    final theme = Theme.of(context);
    final brand = context.brand;

    if (gym == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 48, 28, 40),
            children: [
              Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(brand.radius * 0.7),
                    ),
                    child: Icon(
                      gymIcon(gym.icon),
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gym.name, style: theme.textTheme.titleLarge),
                      Text(
                        'Admin dashboard',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: brand.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                context.brand.titleStyle == TitleStyle.athletic
                    ? 'STAFF LOGIN'
                    : 'Staff login',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Members use the gym app. This web console is for ${gym.name} staff only.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: brand.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: _obscure,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              if (session.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  session.errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),
              BrandedButton(
                label: 'Enter dashboard',
                loading: session.isAuthenticating,
                onPressed: _submit,
              ),
              const SizedBox(height: 28),
              Text(
                'Demo staff',
                style: theme.textTheme.titleSmall?.copyWith(color: brand.muted),
              ),
              const SizedBox(height: 6),
              Text(
                'Password: 123456',
                style: theme.textTheme.bodySmall?.copyWith(color: brand.muted),
              ),
              const SizedBox(height: 12),
              ...session.demoAdmins.map(
                (admin) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: brand.surfaceVariant,
                    borderRadius: brand.cardRadius,
                    child: InkWell(
                      borderRadius: brand.cardRadius,
                      onTap: () {
                        _email.text = admin.email;
                        _password.text = '123456';
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    admin.name,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  Text(
                                    '${admin.email} · ${admin.role}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: brand.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: brand.muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
