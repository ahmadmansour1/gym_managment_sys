import 'package:flutter/material.dart';

import '../../core/theme/brand_theme_extension.dart';
import '../../domain/entities/brand_theme.dart';

class BrandedButton extends StatelessWidget {
  const BrandedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = true,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          )
        : Text(_styledLabel(context, label));

    final button = FilledButton(
      onPressed: loading ? null : onPressed,
      child: child,
    );

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  String _styledLabel(BuildContext context, String value) {
    final style = context.brand.titleStyle;
    if (style == TitleStyle.athletic) return value.toUpperCase();
    return value;
  }
}

IconData gymIcon(String name) {
  return switch (name) {
    'spa' => Icons.spa_rounded,
    'bolt' => Icons.bolt_rounded,
    _ => Icons.fitness_center_rounded,
  };
}
