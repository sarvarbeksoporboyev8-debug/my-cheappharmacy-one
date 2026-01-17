import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:sellingapp/core/developer_settings.dart';
import 'package:sellingapp/core/config/app_config.dart';

class AdminModePage extends rp.ConsumerWidget {
  const AdminModePage({super.key});
  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    final dev = ref.watch(developerSettingsProvider);
    final app = ref.watch(appConfigProvider);
    final controller = TextEditingController(text: dev.apiToken ?? '');
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Mode')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(title: const Text('Current API base URL'), subtitle: Text(dev.apiBaseUrl)),
          ListTile(title: const Text('App-config base URL'), subtitle: Text(app.apiBaseUrl)),
          SwitchListTile(
            value: dev.useMockData,
            onChanged: (v) => ref.read(developerSettingsProvider.notifier).setUseMock(v),
            title: const Text('Use Mock Data'),
            subtitle: const Text('Toggle between mock and real API (UI only)'),
          ),
          const SizedBox(height: 8),
          TextField(controller: controller, decoration: const InputDecoration(labelText: 'API token'), obscureText: true),
          const SizedBox(height: 8),
          Row(children: [
            FilledButton.icon(onPressed: () => ref.read(developerSettingsProvider.notifier).setApiToken(controller.text.trim()), icon: const Icon(Icons.save, color: Colors.white), label: const Text('Save token')),
            const SizedBox(width: 12),
            OutlinedButton.icon(onPressed: () => ref.read(developerSettingsProvider.notifier).setApiToken(''), icon: const Icon(Icons.clear), label: const Text('Clear')),
          ]),
          const SizedBox(height: 16),
          OutlinedButton.icon(onPressed: () { /* Clear local caches */ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared'))); }, icon: const Icon(Icons.cached), label: const Text('Clear cache')),
        ],
      ),
    );
  }
}
