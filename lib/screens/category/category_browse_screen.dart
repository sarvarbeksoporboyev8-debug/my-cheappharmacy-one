import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:go_router/go_router.dart';
import 'package:sellingapp/core/providers.dart';
import 'package:sellingapp/models/enterprise.dart';
import 'package:sellingapp/widgets/enterprise_list_item.dart';

final _queryProvider = rp.StateProvider.autoDispose<String>((ref) => '');

final _categoryListProvider = rp.FutureProvider.autoDispose.family<List<Enterprise>, String>((ref, slug) async {
  final repo = ref.watch(shopRepositoryProvider);
  final q = ref.watch(_queryProvider);
  // In lieu of dedicated category endpoints, use shops for most categories
  // and producers for a subset to provide variety.
  final useProducers = <String>{'food', 'agriculture', 'services'}.contains(slug);
  final list = useProducers ? await repo.listProducers(query: q) : await repo.listShops(query: q);
  return list;
});

class CategoryBrowseScreen extends rp.ConsumerStatefulWidget {
  final String slug;
  final String? title;
  const CategoryBrowseScreen({super.key, required this.slug, this.title});

  @override
  rp.ConsumerState<CategoryBrowseScreen> createState() => _CategoryBrowseScreenState();
}

class _CategoryBrowseScreenState extends rp.ConsumerState<CategoryBrowseScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_categoryListProvider(widget.slug));
    final title = widget.title ?? widget.slug[0].toUpperCase() + widget.slug.substring(1);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()), centerTitle: true, title: Text(title)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(prefixIcon: Icon(Icons.search, color: scheme.primary), hintText: 'Search listings'),
            onChanged: (v) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 300), () => ref.read(_queryProvider.notifier).state = v);
            },
          ),
        ),
        Expanded(
          child: async.when(
            data: (items) => items.isEmpty
                ? const Center(child: Text('No results'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => EnterpriseListItem(e: items[i], onTap: () => context.push('/shops/${items[i].id}')),
                  ),
            loading: () => ListView.builder(itemCount: 8, itemBuilder: (_, __) => const _Skeleton()),
            error: (e, st) => Center(child: Text('Error: $e')),
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
