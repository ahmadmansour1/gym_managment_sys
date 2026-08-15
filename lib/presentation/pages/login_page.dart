import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/brand_theme.dart';
import '../state/session_controllers.dart';
import '../widgets/branded_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    await context.read<AppSession>().login(
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AppSession>();
    final gym = session.gym;
    final theme = Theme.of(context);
    final brand = context.brand;

    if (gym == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(brand.radius * 0.7),
                ),
                child: Icon(
                  gymIcon(gym.icon),
                  color: theme.colorScheme.onPrimary,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(gym.name, style: theme.textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(
              gym.tagline,
              style: theme.textTheme.titleMedium?.copyWith(color: brand.muted),
            ),
            const SizedBox(height: 36),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.password],
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
              label: 'Log in',
              loading: session.isAuthenticating,
              onPressed: _submit,
            ),
            const SizedBox(height: 28),
            Text(
              context.brand.titleStyle == TitleStyle.athletic
                  ? 'DEMO MEMBERS'
                  : 'Demo members',
              style: theme.textTheme.titleSmall?.copyWith(color: brand.muted),
            ),
            const SizedBox(height: 8),
            Text(
              'Password for all mock accounts: 123456',
              style: theme.textTheme.bodySmall?.copyWith(color: brand.muted),
            ),
            const SizedBox(height: 12),
            ...session.demoMembers.map(
              (member) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: brand.surfaceVariant,
                  borderRadius: brand.cardRadius,
                  child: InkWell(
                    borderRadius: brand.cardRadius,
                    onTap: () {
                      _email.text = member.email;
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
                                  member.name,
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  member.email,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: brand.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: brand.muted),
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
    );
  }
}
