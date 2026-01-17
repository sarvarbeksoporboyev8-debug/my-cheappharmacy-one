import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:go_router/go_router.dart';
import 'package:sellingapp/models/enterprise.dart';
import 'package:sellingapp/providers/urgency_listings_provider.dart';
import 'package:sellingapp/widgets/enterprise_list_item.dart';

class UrgencyBrowseScreen extends rp.ConsumerStatefulWidget {
  final String window; // e.g., '2h', '8h'
  final String? title;
  const UrgencyBrowseScreen({super.key, required this.window, this.title});

  @override
  rp.ConsumerState<UrgencyBrowseScreen> createState() => _UrgencyBrowseScreenState();
}

class _UrgencyBrowseScreenState extends rp.ConsumerState<UrgencyBrowseScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  int get _hours {
    final s = widget.window.toLowerCase().replaceAll('h', '');
    return int.tryParse(s) ?? 24;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = widget.title ?? 'Urgent Sale';
    final async = ref.watch(urgencyListingsProvider(_hours));
    final sort = ref.watch(urgencySortProvider);
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()), centerTitle: true, title: Text(title)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(prefixIcon: Icon(Icons.search, color: scheme.primary), hintText: 'Search urgent listings'),
            onChanged: (v) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 300), () => ref.read(urgencyQueryProvider.notifier).state = v);
            },
          ),
        ),
        _SortBar(current: sort, onChanged: (s) => ref.read(urgencySortProvider.notifier).state = s),
        Expanded(
          child: async.when(
            data: (items) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(urgencyListingsProvider(_hours));
                await Future<void>.delayed(const Duration(milliseconds: 250));
              },
              child: items.isEmpty
                  ? const ListEmptyState()
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (_, i) => EnterpriseListItem(
                        e: items[i],
                        onTap: () => context.push('/shops/${items[i].id}'),
                      ),
                    ),
            ),
            loading: () => ListView.builder(itemCount: 8, itemBuilder: (_, __) => const _Skeleton()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        )
      ]),
    );
  }
}

class _SortBar extends StatelessWidget {
  final UrgencySort current;
  final ValueChanged<UrgencySort> onChanged;
  const _SortBar({required this.current, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final chips = const [
      UrgencySort.distance,
      UrgencySort.bestValue,
      UrgencySort.soonest,
      UrgencySort.cheapest,
    ];
    final labels = {
      UrgencySort.distance: 'Distance',
      UrgencySort.bestValue: 'Best value',
      UrgencySort.soonest: 'Soonest',
      UrgencySort.cheapest: 'Cheapest',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(children: [
        for (final c in chips)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(labels[c]!),
              selected: c == current,
              onSelected: (_) => onChanged(c),
            ),
          )
      ]),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(12), child: Container(height: 84, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12))));
}

class ListEmptyState extends StatelessWidget {
  const ListEmptyState({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.hourglass_empty, color: scheme.onSurfaceVariant),
        const SizedBox(height: 8),
        Text('No urgent listings found', style: textTheme.titleMedium),
        Text('Try a different filter or broaden your search', style: textTheme.labelMedium),
      ]),
    );
  }
}
