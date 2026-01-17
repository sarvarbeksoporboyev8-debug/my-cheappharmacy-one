import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sellingapp/core/strings.dart';
import 'package:sellingapp/models/enterprise.dart';

// Match the Popular section height
const double kFeaturedCardHeight = 210;

class FeaturedListingCarousel extends StatelessWidget {
  final List<Enterprise> items;
  final void Function(Enterprise) onTap;
  const FeaturedListingCarousel({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    
    return SizedBox(
      height: kFeaturedCardHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final e = items[i];
          return _FeaturedCard(
            enterprise: e,
            onTap: () => onTap(e),
            scheme: scheme,
            textTheme: textTheme,
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatefulWidget {
  final Enterprise enterprise;
  final VoidCallback onTap;
  final ColorScheme scheme;
  final TextTheme textTheme;

  const _FeaturedCard({
    required this.enterprise,
    required this.onTap,
    required this.scheme,
    required this.textTheme,
  });

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.enterprise;
    final scheme = widget.scheme;
    final textTheme = widget.textTheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with Featured badge
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: scheme.surfaceContainerHigh,
                            height: 110,
                            width: double.infinity,
                            child: e.bannerUrl != null
                                ? Image.network(
                                    e.bannerUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _buildPlaceholder(scheme),
                                  )
                                : e.logoUrl != null
                                    ? Image.network(
                                        e.logoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _buildPlaceholder(scheme),
                                      )
                                    : _buildPlaceholder(scheme),
                          ),
                        ),
                        // Featured badge
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppStrings.featuredSectionTitle,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: scheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        // Rating badge
                        if (e.rating != null)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: scheme.surface.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star_rounded, size: 12, color: Colors.amber[700]),
                                  const SizedBox(width: 2),
                                  Text(
                                    e.rating!.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Name
                    Text(
                      e.name.isNotEmpty ? e.name : 'Featured',
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Description
                    Text(
                      e.shortDescription ?? 'Special offer',
                      style: textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (e.pickupAvailable)
                            _MiniChip(icon: Icons.store_rounded, label: 'Pickup', scheme: scheme),
                          if (e.pickupAvailable && e.deliveryAvailable)
                            const SizedBox(width: 6),
                          if (e.deliveryAvailable)
                            _MiniChip(icon: Icons.local_shipping_rounded, label: 'Delivery', scheme: scheme),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme scheme) {
    return Center(
      child: Icon(Icons.storefront_rounded, color: scheme.onSurfaceVariant, size: 32),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme scheme;

  const _MiniChip({required this.icon, required this.label, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
