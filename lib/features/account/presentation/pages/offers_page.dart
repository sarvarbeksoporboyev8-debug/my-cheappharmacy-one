import 'package:flutter/material.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});
  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        bottom: TabBar(controller: _tabs, tabs: const [Tab(text: 'Sent'), Tab(text: 'Received')]),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _MockOffersList(prefix: 'Sent'),
          _MockOffersList(prefix: 'Received'),
        ],
      ),
    );
  }
}

class _MockOffersList extends StatelessWidget {
  final String prefix;
  const _MockOffersList({required this.prefix});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => Card(
        child: ListTile(
          leading: const Icon(Icons.local_offer_outlined),
          title: Text('$prefix offer #${i + 1}'),
          subtitle: const Text('Amount: 120.00 · Status: Pending'),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
