import 'package:flutter/material.dart';
import 'package:sellingapp/models/enterprise.dart';

// Unified height for the Popular preview carousel to avoid overflow on small screens
const double kPopularCardHeight = 210;

class HorizontalListingCarousel extends StatelessWidget {
  final List<Enterprise> items;
  final void Function(Enterprise) onTap;
  const HorizontalListingCarousel({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: kPopularCardHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final e = items[i];
          return InkWell(
            onTap: () => onTap(e),
            child: SizedBox(
              width: 150,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    height: 110,
                    width: double.infinity,
                    child: e.logoUrl == null
                        ? Icon(Icons.image, color: scheme.onSurfaceVariant)
                        : Image.network(e.logoUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, color: scheme.onSurfaceVariant)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(e.name.isNotEmpty ? e.name : 'Listing', style: textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis, softWrap: true),
                Text(e.shortDescription ?? 'Unknown seller', style: textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: true),
                const SizedBox(height: 4),
                // Keep chips on a single horizontal line to prevent vertical growth
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: const [
                    _MiniChip(icon: Icons.place, label: 'Near me'),
                    SizedBox(width: 6),
                    _MiniChip(icon: Icons.timer, label: 'Ends soon'),
                  ]),
                )
              ]),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: items.length,
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon; final String label;
  const _MiniChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: scheme.onSurfaceVariant), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant))]),
    );
  }
}
