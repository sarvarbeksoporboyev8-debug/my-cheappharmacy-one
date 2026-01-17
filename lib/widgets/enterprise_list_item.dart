import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sellingapp/models/enterprise.dart';
import 'package:sellingapp/theme.dart';

/// Google Classroom-style card with scale animation, ripple, and haptic feedback.
class EnterpriseListItem extends StatefulWidget {
  final Enterprise e;
  final VoidCallback? onTap;
  const EnterpriseListItem({super.key, required this.e, this.onTap});

  @override
  State<EnterpriseListItem> createState() => _EnterpriseListItemState();
}

class _EnterpriseListItemState extends State<EnterpriseListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _elevationAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  void _onTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final e = widget.e;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              color: scheme.surface,
              elevation: _elevationAnimation.value,
              shadowColor: scheme.shadow.withOpacity(0.2),
              borderRadius: AppRadius.cardRadius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _onTap,
                splashColor: scheme.primary.withOpacity(0.12),
                highlightColor: scheme.primary.withOpacity(0.06),
                splashFactory: InkSparkle.splashFactory,
                borderRadius: AppRadius.cardRadius,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.cardRadius,
                    border: Border.all(
                      color: scheme.outlineVariant.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner with overlay
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Banner image
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _getAccentColor(e.id),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            child: e.bannerUrl != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                    child: Image.network(
                                      e.bannerUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _buildPlaceholderBanner(e.id),
                                    ),
                                  )
                                : _buildPlaceholderBanner(e.id),
                          ),
                          // Gradient overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.4),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Avatar
                          Positioned(
                            left: 16,
                            bottom: -28,
                            child: _buildAvatar(e, scheme),
                          ),
                          // Rating badge
                          if (e.rating != null)
                            Positioned(
                              right: 12,
                              top: 12,
                              child: _buildRatingBadge(e, scheme, textTheme),
                            ),
                        ],
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.name.isNotEmpty ? e.name : 'Pharmacy',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e.shortDescription ?? 'Health & wellness products',
                              style: textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            _buildServiceChips(e, scheme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(Enterprise e, ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: scheme.surface, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: scheme.primaryContainer,
        backgroundImage: e.logoUrl != null ? NetworkImage(e.logoUrl!) : null,
        child: e.logoUrl == null
            ? Icon(Icons.local_pharmacy_rounded,
                color: scheme.onPrimaryContainer, size: 28)
            : null,
      ),
    );
  }

  Widget _buildRatingBadge(Enterprise e, ColorScheme scheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 18, color: Colors.amber[700]),
          const SizedBox(width: 4),
          Text(
            e.rating!.toStringAsFixed(1),
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChips(Enterprise e, ColorScheme scheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (e.pickupAvailable)
          _ServiceChip(
            icon: Icons.store_rounded,
            label: 'Pickup',
            color: scheme.secondary,
          ),
        if (e.deliveryAvailable)
          _ServiceChip(
            icon: Icons.local_shipping_rounded,
            label: 'Delivery',
            color: scheme.tertiary,
          ),
        if (e.reviewCount != null && e.reviewCount! > 0)
          _ServiceChip(
            icon: Icons.reviews_rounded,
            label: '${e.reviewCount} reviews',
            color: scheme.primary,
          ),
      ],
    );
  }

  Widget _buildPlaceholderBanner(String id) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getAccentColor(id),
            _getAccentColor(id).withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.medical_services_rounded,
          size: 48,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Color _getAccentColor(String id) {
    final colors = [
      const Color(0xFF1A73E8),
      const Color(0xFF00796B),
      const Color(0xFF7B1FA2),
      const Color(0xFFE8710A),
      const Color(0xFF1E8E3E),
      const Color(0xFFC2185B),
      const Color(0xFF5C6BC0),
      const Color(0xFF00ACC1),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }
}

class _ServiceChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ServiceChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact list item with tap animation.
class EnterpriseCompactItem extends StatefulWidget {
  final Enterprise e;
  final VoidCallback? onTap;
  const EnterpriseCompactItem({super.key, required this.e, this.onTap});

  @override
  State<EnterpriseCompactItem> createState() => _EnterpriseCompactItemState();
}

class _EnterpriseCompactItemState extends State<EnterpriseCompactItem>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final e = widget.e;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: scheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onTap?.call();
                },
                borderRadius: BorderRadius.circular(16),
                splashFactory: InkSparkle.splashFactory,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Logo
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: scheme.surfaceContainerHighest,
                            width: 56,
                            height: 56,
                            child: e.logoUrl == null
                                ? Icon(Icons.local_pharmacy_rounded,
                                    color: scheme.onSurfaceVariant)
                                : Image.network(
                                    e.logoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.local_pharmacy_rounded,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.name.isNotEmpty ? e.name : 'Pharmacy',
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (e.rating != null) ...[
                                  const SizedBox(width: 8),
                                  Icon(Icons.star_rounded,
                                      size: 16, color: Colors.amber[700]),
                                  const SizedBox(width: 2),
                                  Text(
                                    e.rating!.toStringAsFixed(1),
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e.shortDescription ?? 'Health products',
                              style: textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                if (e.pickupAvailable)
                                  _MiniChip(label: 'Pickup', scheme: scheme),
                                if (e.pickupAvailable && e.deliveryAvailable)
                                  const SizedBox(width: 6),
                                if (e.deliveryAvailable)
                                  _MiniChip(label: 'Delivery', scheme: scheme),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      Icon(
                        Icons.chevron_right_rounded,
                        color: scheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  final ColorScheme scheme;

  const _MiniChip({required this.label, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
