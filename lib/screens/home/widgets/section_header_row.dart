import 'package:flutter/material.dart';

class SectionHeaderRow extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  const SectionHeaderRow({super.key, required this.title, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: [
        Expanded(child: Text(title, style: textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis)),
        if (actionText != null && onAction != null)
          TextButton(onPressed: onAction, child: Row(children: [Text(actionText!, style: TextStyle(color: scheme.primary)), Icon(Icons.chevron_right, color: scheme.primary)])),
      ]),
    );
  }
}
