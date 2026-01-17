import 'package:flutter/material.dart';
import 'package:sellingapp/screens/home/home_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;

class UrgencySummaryCard extends rp.ConsumerWidget {
  const UrgencySummaryCard({super.key});
  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    final async = ref.watch(homeUrgencyCountsProvider);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: scheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: async.when(
          data: (counts) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _Tile(icon: Icons.flash_on, label: '<2h', value: null, onTap: () => _goUrgency(context, '2h', 'Urgent Sale (<2h)')),
            _Tile(icon: Icons.schedule, label: '<8h', value: null, onTap: () => _goUrgency(context, '8h', 'Urgent Sale (<8h)')),
            _Tile(icon: Icons.calendar_today, label: '<24h', value: null, onTap: () => _goUrgency(context, '24h', 'Urgent Sale (<24h)')),
            _Tile(icon: Icons.event, label: '<48h', value: null, onTap: () => _goUrgency(context, '48h', 'Urgent Sale (<48h)')),
          ]),
          loading: () => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
            _TileSkeleton(), _TileSkeleton(), _TileSkeleton(), _TileSkeleton(),
          ]),
          error: (e, st) => Text('Failed to load', style: TextStyle(color: scheme.error)),
        ),
      ),
    );
  }
}

void _goUrgency(BuildContext context, String window, String title) {
  // Avoid direct dependency on AppRoutes to keep this widget lightweight
  context.push('/urgency/$window', extra: {'title': title});
}

class _Tile extends StatelessWidget {
  final IconData icon; final String label; final String? value; final VoidCallback onTap;
  const _Tile({required this.icon, required this.label, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle), child: Icon(icon, color: scheme.primary)),
        const SizedBox(height: 6),
        // Only show the label as requested; hide numeric counts
        Text(label, style: textTheme.titleSmall),
      ]),
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();
  @override
  Widget build(BuildContext context) => Column(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, shape: BoxShape.circle)),
        const SizedBox(height: 6),
        // Single line to mirror label-only presentation
        Container(width: 36, height: 12, color: Theme.of(context).colorScheme.surfaceContainerHighest),
      ]);
}
