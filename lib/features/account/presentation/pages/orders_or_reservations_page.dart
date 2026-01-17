import 'package:flutter/material.dart';

class OrdersOrReservationsPage extends StatelessWidget {
  const OrdersOrReservationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final chipStyle = Theme.of(context).textTheme.labelSmall;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Orders & Reservations')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: 10,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text('Order #${1000 + i}'),
            subtitle: const Text('Placed on 2025-05-01 · 3 items'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(99)),
              child: Text(i % 2 == 0 ? 'Completed' : 'Active', style: chipStyle?.copyWith(color: scheme.onPrimaryContainer)),
            ),
          ),
        ),
      ),
    );
  }
}
