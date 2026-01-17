import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('FAQs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const _FaqItem(q: 'How do I post a listing?', a: 'Switch to Seller mode in Account > My Listings and tap New listing.'),
          const _FaqItem(q: 'Can I get alerts for deals near me?', a: 'Yes. Enable notifications in Account > Notifications and set your radius.'),
          const _FaqItem(q: 'How are orders handled?', a: 'Buyers can reserve or purchase. Sellers confirm and coordinate pickup or delivery.'),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Contact us'),
            subtitle: const Text('support@urgentsale.app'),
            onTap: () async {
              await Clipboard.setData(const ClipboardData(text: 'support@urgentsale.app'));
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email copied to clipboard')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Report a problem'),
            subtitle: const Text('Open GitHub issues'),
            onTap: () async {
              await Clipboard.setData(const ClipboardData(text: 'https://github.com/your-org/urgent-sale/issues'));
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Issue tracker URL copied')));
            },
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(q, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(a, style: Theme.of(context).textTheme.bodySmall),
        ]),
      );
}
