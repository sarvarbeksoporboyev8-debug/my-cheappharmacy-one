import 'package:flutter/material.dart';
import 'package:sellingapp/theme.dart';

class AccountSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const AccountSectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge?.semiBold.withColor(scheme.onSurface)),
          ),
          ...children,
        ]),
      ),
    );
  }
}
