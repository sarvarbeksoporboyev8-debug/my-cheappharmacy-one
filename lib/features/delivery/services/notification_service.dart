import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellingapp/models/delivery.dart';

/// In-app notification for delivery updates
/// In production, this would integrate with Firebase Cloud Messaging or similar
class DeliveryNotification {
  final String id;
  final String title;
  final String body;
  final DeliveryStatus? status;
  final DateTime timestamp;
  final bool isRead;
  
  const DeliveryNotification({
    required this.id,
    required this.title,
    required this.body,
    this.status,
    required this.timestamp,
    this.isRead = false,
  });
  
  DeliveryNotification copyWith({bool? isRead}) => DeliveryNotification(
    id: id,
    title: title,
    body: body,
    status: status,
    timestamp: timestamp,
    isRead: isRead ?? this.isRead,
  );
}

class NotificationState {
  final List<DeliveryNotification> notifications;
  final int unreadCount;
  
  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
  });
  
  NotificationState copyWith({
    List<DeliveryNotification>? notifications,
    int? unreadCount,
  }) => NotificationState(
    notifications: notifications ?? this.notifications,
    unreadCount: unreadCount ?? this.unreadCount,
  );
}

class NotificationNotifier extends Notifier<NotificationState> {
  @override
  NotificationState build() => const NotificationState();
  
  /// Add a notification for delivery status change
  void addDeliveryNotification(DeliveryRequest delivery) {
    final notification = _createNotificationForStatus(delivery);
    if (notification == null) return;
    
    state = state.copyWith(
      notifications: [notification, ...state.notifications],
      unreadCount: state.unreadCount + 1,
    );
  }
  
  DeliveryNotification? _createNotificationForStatus(DeliveryRequest delivery) {
    String title;
    String body;
    
    switch (delivery.status) {
      case DeliveryStatus.driverAssigned:
        title = 'Driver Found!';
        body = '${delivery.assignedDriver?.name ?? "A driver"} is on the way to pick up your order.';
        break;
      case DeliveryStatus.arrivedAtPickup:
        title = 'Driver at Shop';
        body = 'Your driver has arrived at ${delivery.pickupName} to collect your order.';
        break;
      case DeliveryStatus.pickedUp:
        title = 'Order Picked Up';
        body = 'Your order is on its way! Estimated arrival: ${delivery.estimatedMinutesRemaining ?? "soon"} min.';
        break;
      case DeliveryStatus.arrivedAtDropoff:
        title = 'Driver Arrived';
        body = 'Your driver has arrived at your location. Please collect your order.';
        break;
      case DeliveryStatus.delivered:
        title = 'Order Delivered';
        body = 'Your order has been delivered. Enjoy!';
        break;
      case DeliveryStatus.cancelled:
        title = 'Order Cancelled';
        body = delivery.cancellationReason ?? 'Your order has been cancelled.';
        break;
      default:
        return null;
    }
    
    return DeliveryNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      status: delivery.status,
      timestamp: DateTime.now(),
    );
  }
  
  void markAsRead(String notificationId) {
    final index = state.notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;
    
    final notification = state.notifications[index];
    if (notification.isRead) return;
    
    final updated = List<DeliveryNotification>.from(state.notifications);
    updated[index] = notification.copyWith(isRead: true);
    
    state = state.copyWith(
      notifications: updated,
      unreadCount: (state.unreadCount - 1).clamp(0, state.notifications.length),
    );
  }
  
  void markAllAsRead() {
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(notifications: updated, unreadCount: 0);
  }
  
  void clearAll() {
    state = const NotificationState();
  }
}

final notificationProvider = NotifierProvider<NotificationNotifier, NotificationState>(
  () => NotificationNotifier(),
);

/// Widget to show in-app notification banner
class DeliveryNotificationBanner extends ConsumerWidget {
  final DeliveryNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  
  const DeliveryNotificationBanner({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              _buildStatusIcon(notification.status, scheme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      notification.body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onDismiss,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusIcon(DeliveryStatus? status, ColorScheme scheme) {
    IconData icon;
    Color color;
    
    switch (status) {
      case DeliveryStatus.driverAssigned:
        icon = Icons.person;
        color = scheme.primary;
        break;
      case DeliveryStatus.arrivedAtPickup:
        icon = Icons.store;
        color = Colors.orange;
        break;
      case DeliveryStatus.pickedUp:
        icon = Icons.local_shipping;
        color = scheme.secondary;
        break;
      case DeliveryStatus.arrivedAtDropoff:
        icon = Icons.location_on;
        color = Colors.green;
        break;
      case DeliveryStatus.delivered:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case DeliveryStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.red;
        break;
      default:
        icon = Icons.notifications;
        color = scheme.primary;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

/// Overlay manager for showing notification banners
class NotificationOverlay {
  static OverlayEntry? _currentEntry;
  
  static void show(
    BuildContext context,
    DeliveryNotification notification, {
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    _currentEntry?.remove();
    
    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, -50 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: DeliveryNotificationBanner(
            notification: notification,
            onTap: () {
              _currentEntry?.remove();
              _currentEntry = null;
              onTap?.call();
            },
            onDismiss: () {
              _currentEntry?.remove();
              _currentEntry = null;
            },
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_currentEntry!);
    
    // Auto-dismiss after duration
    Future.delayed(duration, () {
      _currentEntry?.remove();
      _currentEntry = null;
    });
  }
  
  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
