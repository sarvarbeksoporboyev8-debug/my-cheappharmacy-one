import 'package:flutter/material.dart';

/// Top bar with location pill, info pill, and notifications bell.
class HomeTopBar extends StatelessWidget {
  final String? locationName;
  final String infoText;
  final VoidCallback onLocationTap;
  final VoidCallback onInfoTap;
  final VoidCallback onBellTap;
  const HomeTopBar({super.key, this.locationName, required this.infoText, required this.onLocationTap, required this.onInfoTap, required this.onBellTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(children: [
      Expanded(
        child: _PillButton(
          onTap: onLocationTap,
          child: Row(children: [
            Icon(Icons.location_on, color: scheme.primary, size: 18),
            const SizedBox(width: 6),
            Expanded(child: Text(locationName?.isNotEmpty == true ? locationName! : 'Set your location', style: textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
        ),
      ),
      const SizedBox(width: 8),
      _PillButton(onTap: onInfoTap, child: Text(infoText, style: textTheme.labelLarge)),
      const SizedBox(width: 8),
      IconButton(onPressed: onBellTap, icon: Icon(Icons.notifications_none, color: scheme.onSurfaceVariant)),
    ]);
  }
}

class _PillButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PillButton({required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), child: child),
      ),
    );
  }
}
