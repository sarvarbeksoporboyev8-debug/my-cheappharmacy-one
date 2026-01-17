import 'package:flutter/material.dart';

class MyListingsPage extends StatelessWidget {
  const MyListingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Icons.storefront, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text('Seller mode is not enabled. Switch to Seller mode to post.', style: Theme.of(context).textTheme.bodyMedium)),
            ]),
          ),
          const SizedBox(height: 16),
          Text('Your urgent sale listings', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(3, (i) => Card(child: ListTile(leading: const Icon(Icons.local_offer), title: Text('Listing draft ${i + 1}'), subtitle: const Text('Tap to edit...'), trailing: const Icon(Icons.chevron_right)))).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('New listing')),
    );
  }
}
