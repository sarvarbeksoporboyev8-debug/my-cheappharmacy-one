import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:sellingapp/core/settings.dart';
import 'package:sellingapp/core/theme_controller.dart';

class AppearancePage extends rp.ConsumerWidget {
  const AppearancePage({super.key});
  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: mode,
              items: const [DropdownMenuItem(value: ThemeMode.system, child: Text('System')), DropdownMenuItem(value: ThemeMode.light, child: Text('Light')), DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark'))],
              onChanged: (v) => v != null ? ref.read(themeModeProvider.notifier).setMode(v) : null,
            ),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: settings.language,
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'uz', child: Text('Uzbek')),
                DropdownMenuItem(value: 'ru', child: Text('Russian')),
              ],
              onChanged: (v) => v != null ? ref.read(settingsProvider.notifier).setLanguage(v) : null,
            ),
          ),
        ],
      ),
    );
  }
}
