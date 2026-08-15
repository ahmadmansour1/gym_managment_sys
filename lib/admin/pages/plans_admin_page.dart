import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../presentation/widgets/branded_button.dart';
import '../state/admin_session.dart';

class PlansAdminPage extends StatelessWidget {
  const PlansAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AdminSession>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Membership plans',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              FilledButton.icon(
                onPressed: () => showAddPlanDialog(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add plan'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'These are the durations members can buy: 1 month, 3 months, and so on.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.brand.muted),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView.separated(
              itemCount: session.plans.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final plan = session.plans[index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: context.brand.cardRadius,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plan.description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: context.brand.muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            plan.priceLabel,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Text(
                            plan.periodLabel,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: context.brand.muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showAddPlanDialog(BuildContext context) async {
  final name = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  var months = 1;
  final session = context.read<AdminSession>();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add plan'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: description,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price (USD)'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: months,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('1 month')),
                      DropdownMenuItem(value: 3, child: Text('3 months')),
                      DropdownMenuItem(value: 6, child: Text('6 months')),
                      DropdownMenuItem(value: 12, child: Text('12 months')),
                    ],
                    onChanged: (value) => setState(() => months = value ?? 1),
                    decoration: const InputDecoration(labelText: 'Duration'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Close'),
              ),
              BrandedButton(
                expand: false,
                label: 'Save',
                onPressed: () async {
                  final parsed = double.tryParse(price.text) ?? 0;
                  final error = await session.addPlan(
                    name: name.text,
                    description: description.text,
                    price: parsed,
                    durationMonths: months,
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

  name.dispose();
  description.dispose();
  price.dispose();
}
