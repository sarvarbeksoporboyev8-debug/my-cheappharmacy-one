import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:sellingapp/core/settings.dart';

class LocationSettingsPage extends rp.ConsumerWidget {
  const LocationSettingsPage({super.key});
  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Location & Radius')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            const Icon(Icons.my_location),
            const SizedBox(width: 8),
            Text('Permission status: Not requested', style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.settings), label: const Text('Manage')),
          ]),
          const SizedBox(height: 16),
          Text('Default radius (${settings.radiusKm.toStringAsFixed(0)} km)', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 5,
            max: 200,
            value: settings.radiusKm.clamp(5, 200),
            onChanged: (v) => ref.read(settingsProvider.notifier).setRadius(v),
          ),
          const SizedBox(height: 8),
          Text('Default location', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_location_alt), label: const Text('Set manually')),
        ],
      ),
    );
  }
}
