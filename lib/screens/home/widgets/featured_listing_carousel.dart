import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sellingapp/core/strings.dart';
import 'package:sellingapp/models/enterprise.dart';

// Match the Popular section height - increased for larger cards
const double kFeaturedCardHeight = 260;

class FeaturedListingCarousel extends StatelessWidget {
  final List<Enterprise> items;
  final void Function(Enterprise) onTap;
  const FeaturedListingCarousel({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    // Calculate card width to fit ~2.5 cards on screen
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2.5;
    
    return SizedBox(
      height: kFeaturedCardHeight,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final e = items[i];
          return _FeaturedCard(
            enterprise: e,
            onTap: () => onTap(e),
            scheme: scheme,
            textTheme: textTheme,
            cardWidth: cardWidth,
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
  final double cardWidth;

  const _FeaturedCard({
    required this.enterprise,
    required this.onTap,
    required this.scheme,
    required this.textTheme,
    required this.cardWidth,
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
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: widget.cardWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with Featured badge
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            color: scheme.surfaceContainerHigh,
                            height: 140,
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
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              AppStrings.featuredSectionTitle,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: scheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                        // Rating badge
                        if (e.rating != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: scheme.surface.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star_rounded, size: 14, color: Colors.amber[700]),
                                  const SizedBox(width: 3),
                                  Text(
                                    e.rating!.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Name
                    Text(
                      e.name.isNotEmpty ? e.name : 'Featured',
                      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Description
                    Text(
                      e.shortDescription ?? 'Special offer',
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (e.pickupAvailable)
                            _MiniChip(icon: Icons.store_rounded, label: 'Pickup', scheme: scheme),
                          if (e.pickupAvailable && e.deliveryAvailable)
                            const SizedBox(width: 8),
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
      child: Icon(Icons.storefront_rounded, color: scheme.onSurfaceVariant, size: 48),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.onSurfaceVariant),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
