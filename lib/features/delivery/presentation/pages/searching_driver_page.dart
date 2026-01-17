import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellingapp/models/delivery.dart';
import 'package:sellingapp/features/delivery/services/delivery_service.dart';
import 'package:sellingapp/theme.dart';

class SearchingDriverPage extends ConsumerStatefulWidget {
  final String deliveryId;
  
  const SearchingDriverPage({super.key, required this.deliveryId});
  
  @override
  ConsumerState<SearchingDriverPage> createState() => _SearchingDriverPageState();
}

class _SearchingDriverPageState extends ConsumerState<SearchingDriverPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  StreamSubscription<DeliveryRequest>? _deliverySubscription;
  
  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _rotateController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Listen for driver assignment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = ref.read(deliveryServiceProvider);
      final stream = service.getDeliveryStream(widget.deliveryId);
      
      _deliverySubscription = stream?.listen((delivery) {
        if (delivery.status == DeliveryStatus.driverAssigned) {
          // Driver found! Navigate to tracking
          context.go('/delivery/tracking/${widget.deliveryId}');
        } else if (delivery.status == DeliveryStatus.cancelled) {
          // Cancelled
          context.go('/');
        }
      });
    });
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _deliverySubscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            children: [
              const Spacer(),
              
              // Animated search indicator
              _buildSearchAnimation(scheme),
              
              const SizedBox(height: 48),
              
              // Status text
              Text(
                'Looking for a driver nearby...',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'This usually takes less than a minute.\nWe\'ll notify you when a driver accepts.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Animated dots
              _buildLoadingDots(scheme),
              
              const Spacer(),
              
              // Cancel button
              OutlinedButton.icon(
                onPressed: () => _showCancelDialog(),
                icon: const Icon(Icons.close),
                label: const Text('Cancel Order'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSearchAnimation(ColorScheme scheme) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulsing rings
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final delay = index * 0.3;
                final progress = (_pulseController.value + delay) % 1.0;
                final scale = 0.5 + (progress * 0.8);
                final opacity = (1.0 - progress).clamp(0.0, 0.5);
                
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: scheme.primary.withOpacity(opacity),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          
          // Rotating car icons
          AnimatedBuilder(
            animation: _rotateController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    children: List.generate(4, (index) {
                      final angle = (index * math.pi / 2);
                      return Positioned(
                        left: 80 + 60 * math.cos(angle) - 16,
                        top: 80 + 60 * math.sin(angle) - 16,
                        child: Transform.rotate(
                          angle: -_rotateController.value * 2 * math.pi + angle + math.pi / 2,
                          child: Icon(
                            Icons.directions_car,
                            color: scheme.primary.withOpacity(0.6),
                            size: 32,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          ),
          
          // Center icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search,
                    color: scheme.primary,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingDots(ColorScheme scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final delay = index * 0.2;
            final progress = (_pulseController.value + delay) % 1.0;
            final scale = 0.5 + (0.5 * math.sin(progress * math.pi));
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
  
  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text(
          'Are you sure you want to cancel this order? '
          'Your payment will be refunded.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Searching'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(deliveryServiceProvider).cancelDelivery(
                widget.deliveryId,
                'Customer cancelled before driver assignment',
              );
              Navigator.pop(context);
              context.go('/');
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }
}
