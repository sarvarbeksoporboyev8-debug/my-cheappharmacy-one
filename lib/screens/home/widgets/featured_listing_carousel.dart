import 'package:flutter/material.dart';
import 'package:sellingapp/core/strings.dart';
import 'package:sellingapp/models/enterprise.dart';

class FeaturedListingCarousel extends StatefulWidget {
  final List<Enterprise> items;
  final void Function(Enterprise) onTap;
  const FeaturedListingCarousel({super.key, required this.items, required this.onTap});

  @override
  State<FeaturedListingCarousel> createState() => _FeaturedListingCarouselState();
}

class _FeaturedListingCarouselState extends State<FeaturedListingCarousel> {
  final _controller = PageController(viewportFraction: 0.92);
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 250,
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (i) => setState(() => _index = i),
          itemCount: widget.items.length,
          itemBuilder: (_, i) {
            final e = widget.items[i];
            return GestureDetector(
              onTap: () => widget.onTap(e),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(children: [
                    Container(color: Theme.of(context).colorScheme.surfaceContainerHigh),
                    Positioned.fill(
                      child: e.logoUrl == null
                          ? Center(child: Icon(Icons.image, color: scheme.onSurfaceVariant))
                          : Image.network(e.logoUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Center(child: Icon(Icons.broken_image, color: scheme.onSurfaceVariant))),
                    ),
                    Positioned(top: 12, left: 12, child: _LabelChip(text: AppStrings.featuredSectionTitle)),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: scheme.surface.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(12)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(e.name.isNotEmpty ? e.name : 'Featured', style: textTheme.titleMedium),
                            Text(e.shortDescription ?? 'Near me', style: textTheme.labelMedium),
                          ]),
                        ),
                      ]),
                    )
                  ]),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(widget.items.length, (i) {
        final active = i == _index;
        return AnimatedContainer(duration: const Duration(milliseconds: 250), margin: const EdgeInsets.symmetric(horizontal: 3), width: active ? 18 : 6, height: 6, decoration: BoxDecoration(color: active ? scheme.primary : scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(3)));
      })),
    ]);
  }
}

class _LabelChip extends StatelessWidget {
  final String text;
  const _LabelChip({required this.text});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}
