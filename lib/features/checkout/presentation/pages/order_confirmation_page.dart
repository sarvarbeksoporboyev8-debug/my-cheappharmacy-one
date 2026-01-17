import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellingapp/nav.dart';
import 'package:sellingapp/theme.dart';
import 'package:sellingapp/models/delivery.dart';
import 'package:sellingapp/features/delivery/services/delivery_service.dart';
import 'package:sellingapp/features/checkout/presentation/state/checkout_state.dart';

class OrderConfirmationPage extends ConsumerStatefulWidget {
  const OrderConfirmationPage({super.key});
  
  @override
  ConsumerState<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends ConsumerState<OrderConfirmationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isCreatingDelivery = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Future<void> _startDelivery() async {
    if (_isCreatingDelivery) return;
    
    setState(() => _isCreatingDelivery = true);
    
    final checkoutData = ref.read(checkoutProvider);
    final deliveryService = ref.read(deliveryServiceProvider);
    
    // Create delivery request
    // In production, these would come from the actual order and user location
    final delivery = await deliveryService.createDeliveryRequest(
      orderId: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      pickupLocation: const GeoLocation(latitude: 40.7128, longitude: -74.0060),
      pickupAddress: '123 Market Street',
      pickupName: 'FreshBite Market',
      dropoffLocation: const GeoLocation(latitude: 40.7200, longitude: -74.0100),
      dropoffAddress: checkoutData.address1.isNotEmpty 
          ? checkoutData.address1 
          : '456 Customer Ave',
      customerName: checkoutData.name.isNotEmpty 
          ? checkoutData.name 
          : 'Customer',
      customerPhone: '+1 555-0100',
      deliveryFee: 3.99,
    );
    
    if (mounted) {
      context.go(AppRoutes.searchingDriverPath(delivery.id));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final checkoutData = ref.watch(checkoutProvider);
    final isDelivery = checkoutData.method == 'delivery';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated checkmark
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 80,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Order Placed Successfully!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Subtitle
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  isDelivery
                      ? 'Your order is being prepared. Track your delivery in real-time.'
                      : 'Your order is being prepared. We\'ll notify you when it\'s ready for pickup.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Order summary card
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingMd,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt_long, color: scheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Order Details',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Order #', 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'),
                      _buildDetailRow('Method', isDelivery ? 'Delivery' : 'Pickup'),
                      if (checkoutData.address1.isNotEmpty)
                        _buildDetailRow('Address', checkoutData.address1),
                      _buildDetailRow('Payment', checkoutData.payment == 'card' ? 'Card' : 'Wallet'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Delivery info card (only for delivery orders)
              if (isDelivery)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: AppSpacing.paddingMd,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: scheme.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.delivery_dining,
                          color: scheme.primary,
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ready for Delivery',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap below to find a driver and track your order in real-time',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Action buttons
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    if (isDelivery)
                      FilledButton.icon(
                        onPressed: _isCreatingDelivery ? null : _startDelivery,
                        icon: _isCreatingDelivery
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: scheme.onPrimary,
                                ),
                              )
                            : const Icon(Icons.local_shipping),
                        label: Text(_isCreatingDelivery 
                            ? 'Finding Driver...' 
                            : 'Track Delivery'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                        ),
                      )
                    else
                      FilledButton.icon(
                        onPressed: () => context.go(AppRoutes.discover),
                        icon: const Icon(Icons.check),
                        label: const Text('Done'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                        ),
                      ),
                    
                    const SizedBox(height: 12),
                    
                    OutlinedButton(
                      onPressed: () => context.go(AppRoutes.discover),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Continue Shopping'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
