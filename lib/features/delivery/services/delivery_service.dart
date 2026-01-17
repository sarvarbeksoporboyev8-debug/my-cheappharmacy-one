import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellingapp/models/delivery.dart';

/// Mock drivers for demo
final List<Driver> _mockDrivers = [
  Driver(
    id: 'd1',
    name: 'Alex Johnson',
    phone: '+1 555-0101',
    photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
    vehicleType: 'car',
    vehiclePlate: 'ABC 123',
    rating: 4.9,
    completedDeliveries: 1247,
    currentLocation: const GeoLocation(latitude: 40.7128, longitude: -74.0060),
    isAvailable: true,
  ),
  Driver(
    id: 'd2',
    name: 'Maria Garcia',
    phone: '+1 555-0102',
    photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=200&fit=crop',
    vehicleType: 'scooter',
    vehiclePlate: 'XYZ 789',
    rating: 4.8,
    completedDeliveries: 892,
    currentLocation: const GeoLocation(latitude: 40.7148, longitude: -74.0080),
    isAvailable: true,
  ),
  Driver(
    id: 'd3',
    name: 'James Wilson',
    phone: '+1 555-0103',
    photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop',
    vehicleType: 'bike',
    vehiclePlate: 'BIKE-42',
    rating: 4.7,
    completedDeliveries: 456,
    currentLocation: const GeoLocation(latitude: 40.7108, longitude: -74.0040),
    isAvailable: true,
  ),
  Driver(
    id: 'd4',
    name: 'Sarah Chen',
    phone: '+1 555-0104',
    photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop',
    vehicleType: 'car',
    vehiclePlate: 'DEF 456',
    rating: 4.95,
    completedDeliveries: 2103,
    currentLocation: const GeoLocation(latitude: 40.7168, longitude: -74.0100),
    isAvailable: true,
  ),
];

/// Delivery service for managing deliveries
class DeliveryService {
  final Map<String, DeliveryRequest> _activeDeliveries = {};
  final Map<String, StreamController<DeliveryRequest>> _deliveryStreams = {};
  final Map<String, Timer> _simulationTimers = {};
  
  /// Find nearby available drivers
  List<Driver> findNearbyDrivers(GeoLocation pickupLocation, {double radiusKm = 5.0}) {
    return _mockDrivers
        .where((d) => d.isAvailable)
        .where((d) => d.currentLocation.distanceTo(pickupLocation) <= radiusKm)
        .toList()
      ..sort((a, b) => a.currentLocation.distanceTo(pickupLocation)
          .compareTo(b.currentLocation.distanceTo(pickupLocation)));
  }
  
  /// Create a new delivery request
  Future<DeliveryRequest> createDeliveryRequest({
    required String orderId,
    required GeoLocation pickupLocation,
    required String pickupAddress,
    required String pickupName,
    required GeoLocation dropoffLocation,
    required String dropoffAddress,
    required String customerName,
    required String customerPhone,
    required double deliveryFee,
  }) async {
    final id = 'del_${DateTime.now().millisecondsSinceEpoch}';
    
    final request = DeliveryRequest(
      id: id,
      orderId: orderId,
      status: DeliveryStatus.pending,
      pickupLocation: pickupLocation,
      pickupAddress: pickupAddress,
      pickupName: pickupName,
      dropoffLocation: dropoffLocation,
      dropoffAddress: dropoffAddress,
      customerName: customerName,
      customerPhone: customerPhone,
      createdAt: DateTime.now(),
      deliveryFee: deliveryFee,
    );
    
    _activeDeliveries[id] = request;
    _deliveryStreams[id] = StreamController<DeliveryRequest>.broadcast();
    _deliveryStreams[id]!.add(request);
    
    // Start driver matching simulation
    _simulateDriverMatching(id);
    
    return request;
  }
  
  /// Get delivery stream for real-time updates
  Stream<DeliveryRequest>? getDeliveryStream(String deliveryId) {
    return _deliveryStreams[deliveryId]?.stream;
  }
  
  /// Get current delivery state
  DeliveryRequest? getDelivery(String deliveryId) {
    return _activeDeliveries[deliveryId];
  }
  
  /// Simulate driver matching (demo mode)
  void _simulateDriverMatching(String deliveryId) {
    // Simulate 3-8 seconds to find a driver
    final delay = Duration(seconds: 3 + (DateTime.now().millisecond % 5));
    
    _simulationTimers[deliveryId] = Timer(delay, () {
      final delivery = _activeDeliveries[deliveryId];
      if (delivery == null || delivery.status != DeliveryStatus.pending) return;
      
      // Find nearest driver
      final drivers = findNearbyDrivers(delivery.pickupLocation);
      if (drivers.isEmpty) {
        // No drivers available - in real app would retry or notify user
        return;
      }
      
      final driver = drivers.first;
      final distance = driver.currentLocation.distanceTo(delivery.pickupLocation);
      final pickupMinutes = (distance * 3).round() + 2; // ~3 min per km + 2 min buffer
      final deliveryDistance = delivery.pickupLocation.distanceTo(delivery.dropoffLocation);
      final deliveryMinutes = (deliveryDistance * 4).round() + 5; // ~4 min per km + 5 min for handoff
      
      final updated = delivery.copyWith(
        status: DeliveryStatus.driverAssigned,
        assignedDriver: driver,
        estimatedPickupTime: DateTime.now().add(Duration(minutes: pickupMinutes)),
        estimatedDeliveryTime: DateTime.now().add(Duration(minutes: pickupMinutes + deliveryMinutes)),
      );
      
      _updateDelivery(updated);
      
      // Continue simulation
      _simulateDeliveryProgress(deliveryId);
    });
  }
  
  /// Simulate delivery progress through all stages
  void _simulateDeliveryProgress(String deliveryId) {
    final stages = [
      (DeliveryStatus.arrivedAtPickup, const Duration(seconds: 15)),
      (DeliveryStatus.pickedUp, const Duration(seconds: 10)),
      (DeliveryStatus.arrivedAtDropoff, const Duration(seconds: 20)),
      (DeliveryStatus.delivered, const Duration(seconds: 8)),
    ];
    
    var totalDelay = Duration.zero;
    
    for (final stage in stages) {
      totalDelay += stage.$2;
      
      Timer(totalDelay, () {
        final delivery = _activeDeliveries[deliveryId];
        if (delivery == null || delivery.status == DeliveryStatus.cancelled) return;
        
        DeliveryRequest updated;
        if (stage.$1 == DeliveryStatus.delivered) {
          updated = delivery.copyWith(
            status: stage.$1,
            actualDeliveryTime: DateTime.now(),
          );
        } else {
          updated = delivery.copyWith(status: stage.$1);
        }
        
        _updateDelivery(updated);
      });
    }
  }
  
  /// Update delivery and notify listeners
  void _updateDelivery(DeliveryRequest delivery) {
    _activeDeliveries[delivery.id] = delivery;
    _deliveryStreams[delivery.id]?.add(delivery);
  }
  
  /// Cancel a delivery
  Future<void> cancelDelivery(String deliveryId, String reason) async {
    final delivery = _activeDeliveries[deliveryId];
    if (delivery == null) return;
    
    // Cancel simulation timer
    _simulationTimers[deliveryId]?.cancel();
    
    final updated = delivery.copyWith(
      status: DeliveryStatus.cancelled,
      cancellationReason: reason,
    );
    
    _updateDelivery(updated);
  }
  
  /// Confirm delivery received
  Future<void> confirmDelivery(String deliveryId) async {
    final delivery = _activeDeliveries[deliveryId];
    if (delivery == null) return;
    
    final updated = delivery.copyWith(
      status: DeliveryStatus.delivered,
      actualDeliveryTime: DateTime.now(),
    );
    
    _updateDelivery(updated);
  }
  
  /// Clean up resources
  void dispose() {
    for (final timer in _simulationTimers.values) {
      timer.cancel();
    }
    for (final controller in _deliveryStreams.values) {
      controller.close();
    }
  }
}

/// Singleton provider for delivery service
final deliveryServiceProvider = Provider<DeliveryService>((ref) {
  final service = DeliveryService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for active delivery by ID
final activeDeliveryProvider = StreamProvider.family<DeliveryRequest?, String>((ref, deliveryId) {
  final service = ref.watch(deliveryServiceProvider);
  return service.getDeliveryStream(deliveryId) ?? const Stream.empty();
});

/// State for current user's active delivery
class ActiveDeliveryState {
  final String? currentDeliveryId;
  final DeliveryRequest? delivery;
  
  const ActiveDeliveryState({this.currentDeliveryId, this.delivery});
  
  ActiveDeliveryState copyWith({
    String? currentDeliveryId,
    DeliveryRequest? delivery,
  }) => ActiveDeliveryState(
    currentDeliveryId: currentDeliveryId ?? this.currentDeliveryId,
    delivery: delivery ?? this.delivery,
  );
}

class ActiveDeliveryNotifier extends Notifier<ActiveDeliveryState> {
  StreamSubscription<DeliveryRequest>? _subscription;
  
  @override
  ActiveDeliveryState build() => const ActiveDeliveryState();
  
  void setActiveDelivery(String deliveryId) {
    _subscription?.cancel();
    
    final service = ref.read(deliveryServiceProvider);
    final stream = service.getDeliveryStream(deliveryId);
    
    if (stream != null) {
      _subscription = stream.listen((delivery) {
        state = state.copyWith(
          currentDeliveryId: deliveryId,
          delivery: delivery,
        );
      });
    }
    
    state = ActiveDeliveryState(
      currentDeliveryId: deliveryId,
      delivery: service.getDelivery(deliveryId),
    );
  }
  
  void clearActiveDelivery() {
    _subscription?.cancel();
    state = const ActiveDeliveryState();
  }
}

final activeDeliveryStateProvider = NotifierProvider<ActiveDeliveryNotifier, ActiveDeliveryState>(
  () => ActiveDeliveryNotifier(),
);
