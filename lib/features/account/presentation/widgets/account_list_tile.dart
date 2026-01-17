import 'package:flutter/material.dart';
import 'package:sellingapp/theme.dart';

class AccountListTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  const AccountListTile({super.key, required this.icon, this.iconColor, required this.title, required this.subtitle, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor ?? scheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.semiBold.withColor(scheme.onSurface)),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.withColor(scheme.onSurfaceVariant), softWrap: true, overflow: TextOverflow.ellipsis),
            ]),
          ),
          const SizedBox(width: AppSpacing.sm),
          trailing ?? Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
        ]),
      ),
    );
  }
}
