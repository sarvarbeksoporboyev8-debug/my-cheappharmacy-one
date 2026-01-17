/// Delivery status enum representing the lifecycle of a delivery
enum DeliveryStatus {
  pending,          // Order placed, searching for driver
  driverAssigned,   // Driver accepted, heading to pickup
  arrivedAtPickup,  // Driver arrived at shop
  pickedUp,         // Items collected, heading to customer
  arrivedAtDropoff, // Driver arrived at customer location
  delivered,        // Customer confirmed receipt
  cancelled,        // Delivery cancelled
}

/// Location coordinates
class GeoLocation {
  final double latitude;
  final double longitude;
  
  const GeoLocation({required this.latitude, required this.longitude});
  
  factory GeoLocation.fromJson(Map<String, dynamic> json) => GeoLocation(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
  
  Map<String, dynamic> toJson() => {'latitude': latitude, 'longitude': longitude};
  
  /// Calculate approximate distance in km (Haversine simplified)
  double distanceTo(GeoLocation other) {
    const double earthRadius = 6371;
    final dLat = _toRadians(other.latitude - latitude);
    final dLon = _toRadians(other.longitude - longitude);
    final a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(latitude)) * _cos(_toRadians(other.latitude)) *
        _sin(dLon / 2) * _sin(dLon / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }
  
  static double _toRadians(double deg) => deg * 3.14159265359 / 180;
  static double _sin(double x) => _taylorSin(x);
  static double _cos(double x) => _taylorSin(x + 1.5707963268);
  static double _sqrt(double x) => x <= 0 ? 0 : _newtonSqrt(x);
  static double _atan2(double y, double x) {
    if (x > 0) return _taylorAtan(y / x);
    if (x < 0 && y >= 0) return _taylorAtan(y / x) + 3.14159265359;
    if (x < 0 && y < 0) return _taylorAtan(y / x) - 3.14159265359;
    if (x == 0 && y > 0) return 1.5707963268;
    if (x == 0 && y < 0) return -1.5707963268;
    return 0;
  }
  static double _taylorSin(double x) {
    x = x % (2 * 3.14159265359);
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }
  static double _taylorAtan(double x) {
    if (x.abs() > 1) {
      return (x > 0 ? 1 : -1) * 1.5707963268 - _taylorAtan(1 / x);
    }
    double result = x;
    double term = x;
    for (int i = 1; i <= 15; i++) {
      term *= -x * x;
      result += term / (2 * i + 1);
    }
    return result;
  }
  static double _newtonSqrt(double x) {
    double guess = x / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }
}

/// Driver model
class Driver {
  final String id;
  final String name;
  final String phone;
  final String photoUrl;
  final String vehicleType; // car, bike, scooter
  final String vehiclePlate;
  final double rating;
  final int completedDeliveries;
  final GeoLocation currentLocation;
  final bool isAvailable;
  
  const Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.photoUrl,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.rating,
    required this.completedDeliveries,
    required this.currentLocation,
    required this.isAvailable,
  });
  
  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    photoUrl: json['photo_url'] as String,
    vehicleType: json['vehicle_type'] as String,
    vehiclePlate: json['vehicle_plate'] as String,
    rating: (json['rating'] as num).toDouble(),
    completedDeliveries: json['completed_deliveries'] as int,
    currentLocation: GeoLocation.fromJson(json['current_location'] as Map<String, dynamic>),
    isAvailable: json['is_available'] as bool,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'photo_url': photoUrl,
    'vehicle_type': vehicleType,
    'vehicle_plate': vehiclePlate,
    'rating': rating,
    'completed_deliveries': completedDeliveries,
    'current_location': currentLocation.toJson(),
    'is_available': isAvailable,
  };
  
  Driver copyWith({
    String? id,
    String? name,
    String? phone,
    String? photoUrl,
    String? vehicleType,
    String? vehiclePlate,
    double? rating,
    int? completedDeliveries,
    GeoLocation? currentLocation,
    bool? isAvailable,
  }) => Driver(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    photoUrl: photoUrl ?? this.photoUrl,
    vehicleType: vehicleType ?? this.vehicleType,
    vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    rating: rating ?? this.rating,
    completedDeliveries: completedDeliveries ?? this.completedDeliveries,
    currentLocation: currentLocation ?? this.currentLocation,
    isAvailable: isAvailable ?? this.isAvailable,
  );
}

/// Delivery request model
class DeliveryRequest {
  final String id;
  final String orderId;
  final DeliveryStatus status;
  final GeoLocation pickupLocation;
  final String pickupAddress;
  final String pickupName; // Shop name
  final GeoLocation dropoffLocation;
  final String dropoffAddress;
  final String customerName;
  final String customerPhone;
  final Driver? assignedDriver;
  final DateTime createdAt;
  final DateTime? estimatedPickupTime;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final List<GeoLocation> driverRoute;
  final double deliveryFee;
  final String? cancellationReason;
  
  const DeliveryRequest({
    required this.id,
    required this.orderId,
    required this.status,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.pickupName,
    required this.dropoffLocation,
    required this.dropoffAddress,
    required this.customerName,
    required this.customerPhone,
    this.assignedDriver,
    required this.createdAt,
    this.estimatedPickupTime,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.driverRoute = const [],
    required this.deliveryFee,
    this.cancellationReason,
  });
  
  factory DeliveryRequest.fromJson(Map<String, dynamic> json) => DeliveryRequest(
    id: json['id'] as String,
    orderId: json['order_id'] as String,
    status: DeliveryStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => DeliveryStatus.pending,
    ),
    pickupLocation: GeoLocation.fromJson(json['pickup_location'] as Map<String, dynamic>),
    pickupAddress: json['pickup_address'] as String,
    pickupName: json['pickup_name'] as String,
    dropoffLocation: GeoLocation.fromJson(json['dropoff_location'] as Map<String, dynamic>),
    dropoffAddress: json['dropoff_address'] as String,
    customerName: json['customer_name'] as String,
    customerPhone: json['customer_phone'] as String,
    assignedDriver: json['assigned_driver'] != null 
        ? Driver.fromJson(json['assigned_driver'] as Map<String, dynamic>) 
        : null,
    createdAt: DateTime.parse(json['created_at'] as String),
    estimatedPickupTime: json['estimated_pickup_time'] != null 
        ? DateTime.parse(json['estimated_pickup_time'] as String) 
        : null,
    estimatedDeliveryTime: json['estimated_delivery_time'] != null 
        ? DateTime.parse(json['estimated_delivery_time'] as String) 
        : null,
    actualDeliveryTime: json['actual_delivery_time'] != null 
        ? DateTime.parse(json['actual_delivery_time'] as String) 
        : null,
    driverRoute: (json['driver_route'] as List?)
        ?.map((e) => GeoLocation.fromJson(e as Map<String, dynamic>))
        .toList() ?? const [],
    deliveryFee: (json['delivery_fee'] as num).toDouble(),
    cancellationReason: json['cancellation_reason'] as String?,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'order_id': orderId,
    'status': status.name,
    'pickup_location': pickupLocation.toJson(),
    'pickup_address': pickupAddress,
    'pickup_name': pickupName,
    'dropoff_location': dropoffLocation.toJson(),
    'dropoff_address': dropoffAddress,
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'assigned_driver': assignedDriver?.toJson(),
    'created_at': createdAt.toIso8601String(),
    'estimated_pickup_time': estimatedPickupTime?.toIso8601String(),
    'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
    'actual_delivery_time': actualDeliveryTime?.toIso8601String(),
    'driver_route': driverRoute.map((e) => e.toJson()).toList(),
    'delivery_fee': deliveryFee,
    'cancellation_reason': cancellationReason,
  };
  
  DeliveryRequest copyWith({
    String? id,
    String? orderId,
    DeliveryStatus? status,
    GeoLocation? pickupLocation,
    String? pickupAddress,
    String? pickupName,
    GeoLocation? dropoffLocation,
    String? dropoffAddress,
    String? customerName,
    String? customerPhone,
    Driver? assignedDriver,
    DateTime? createdAt,
    DateTime? estimatedPickupTime,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    List<GeoLocation>? driverRoute,
    double? deliveryFee,
    String? cancellationReason,
  }) => DeliveryRequest(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    status: status ?? this.status,
    pickupLocation: pickupLocation ?? this.pickupLocation,
    pickupAddress: pickupAddress ?? this.pickupAddress,
    pickupName: pickupName ?? this.pickupName,
    dropoffLocation: dropoffLocation ?? this.dropoffLocation,
    dropoffAddress: dropoffAddress ?? this.dropoffAddress,
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone ?? this.customerPhone,
    assignedDriver: assignedDriver ?? this.assignedDriver,
    createdAt: createdAt ?? this.createdAt,
    estimatedPickupTime: estimatedPickupTime ?? this.estimatedPickupTime,
    estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
    driverRoute: driverRoute ?? this.driverRoute,
    deliveryFee: deliveryFee ?? this.deliveryFee,
    cancellationReason: cancellationReason ?? this.cancellationReason,
  );
  
  /// Get status display text
  String get statusText {
    switch (status) {
      case DeliveryStatus.pending:
        return 'Looking for driver...';
      case DeliveryStatus.driverAssigned:
        return 'Driver on the way to pickup';
      case DeliveryStatus.arrivedAtPickup:
        return 'Driver arrived at shop';
      case DeliveryStatus.pickedUp:
        return 'Order picked up, on the way';
      case DeliveryStatus.arrivedAtDropoff:
        return 'Driver arrived at your location';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
    }
  }
  
  /// Get estimated time remaining in minutes
  int? get estimatedMinutesRemaining {
    if (estimatedDeliveryTime == null) return null;
    final diff = estimatedDeliveryTime!.difference(DateTime.now());
    return diff.inMinutes > 0 ? diff.inMinutes : 0;
  }
}

/// Order with delivery info
class Order {
  final String id;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String status; // pending, confirmed, preparing, ready, out_for_delivery, delivered
  final DateTime createdAt;
  final DeliveryRequest? delivery;
  final String shopId;
  final String shopName;
  
  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
    this.delivery,
    required this.shopId,
    required this.shopName,
  });
  
  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] as String,
    items: (json['items'] as List).map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList(),
    subtotal: (json['subtotal'] as num).toDouble(),
    deliveryFee: (json['delivery_fee'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
    status: json['status'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    delivery: json['delivery'] != null 
        ? DeliveryRequest.fromJson(json['delivery'] as Map<String, dynamic>) 
        : null,
    shopId: json['shop_id'] as String,
    shopName: json['shop_name'] as String,
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items.map((e) => e.toJson()).toList(),
    'subtotal': subtotal,
    'delivery_fee': deliveryFee,
    'total': total,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'delivery': delivery?.toJson(),
    'shop_id': shopId,
    'shop_name': shopName,
  };
}

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  
  const OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });
  
  double get total => price * quantity;
  
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    productId: json['product_id'] as String,
    name: json['name'] as String,
    quantity: json['quantity'] as int,
    price: (json['price'] as num).toDouble(),
  );
  
  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'name': name,
    'quantity': quantity,
    'price': price,
  };
}
