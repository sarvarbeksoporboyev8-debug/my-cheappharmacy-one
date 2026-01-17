import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sellingapp/core/strings.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppStrings.appName),
            subtitle: Text('${AppStrings.appVersion}${kReleaseMode ? '' : ' (dev)'}'),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            subtitle: const Text('View our terms'),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            subtitle: const Text('How we handle your data'),
          ),
          const Divider(height: 0),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text('Acknowledgements', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),
          const Text('This app is built with Flutter and go_router. Icons by Material Icons.'),
        ],
      ),
    );
  }
}
