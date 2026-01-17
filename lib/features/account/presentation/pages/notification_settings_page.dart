import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:sellingapp/core/settings.dart';

class NotificationSettingsPage extends rp.ConsumerWidget {
  const NotificationSettingsPage({super.key});
  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            const Icon(Icons.notifications_active_outlined),
            const SizedBox(width: 8),
            Text('Permission: Not enabled', style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            FilledButton.icon(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('In-app notifications enabled'))); }, icon: const Icon(Icons.check, color: Colors.white), label: const Text('Enable notifications')),
          ]),
          const SizedBox(height: 16),
          SwitchListTile(
            value: s.watchlistAlerts,
            onChanged: (v) => ref.read(settingsProvider.notifier).setWatchlistAlerts(v),
            title: const Text('Watchlist alerts'),
            subtitle: const Text('Get alerts for tracked deals'),
          ),
          SwitchListTile(
            value: s.offerUpdates,
            onChanged: (v) => ref.read(settingsProvider.notifier).setOfferUpdates(v),
            title: const Text('Offer updates'),
            subtitle: const Text('Status changes and messages'),
          ),
          SwitchListTile(
            value: s.reservationUpdates,
            onChanged: (v) => ref.read(settingsProvider.notifier).setReservationUpdates(v),
            title: const Text('Reservation updates'),
            subtitle: const Text('Reminders and confirmations'),
          ),
        ],
      ),
    );
  }
}
