import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:go_router/go_router.dart';
import 'package:sellingapp/core/providers.dart';
import 'package:sellingapp/models/enterprise.dart';
import 'package:sellingapp/nav.dart';
import 'package:sellingapp/theme.dart';
import 'package:sellingapp/core/favorites.dart';
import 'package:sellingapp/widgets/enterprise_list_item.dart';
import 'dart:async';

final discoverQueryProvider = rp.NotifierProvider<_QueryNotifier, String>(() => _QueryNotifier());

class _QueryNotifier extends rp.Notifier<String> {
  @override
  String build() => '';
}

final shopsProvider = rp.FutureProvider<List<Enterprise>>((ref) async {
  final repo = ref.watch(shopRepositoryProvider);
  final q = ref.watch(discoverQueryProvider);
  return repo.listShops(query: q);
});

final producersProvider = rp.FutureProvider<List<Enterprise>>((ref) async {
  final repo = ref.watch(shopRepositoryProvider);
  final q = ref.watch(discoverQueryProvider);
  return repo.listProducers(query: q);
});

class DiscoverPage extends rp.ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  rp.ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends rp.ConsumerState<DiscoverPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  Timer? _debounce;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      children: [
        // Header with search
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar - Google style
              Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
                    hintText: 'Search pharmacies and suppliers',
                    hintStyle: textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded, color: scheme.onSurfaceVariant),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(discoverQueryProvider.notifier).state = '';
                            },
                          )
                        : null,
                  ),
                  onChanged: (v) {
                    setState(() {});
                    _debounce?.cancel();
                    _debounce = Timer(
                      const Duration(milliseconds: 350),
                      () => ref.read(discoverQueryProvider.notifier).state = v,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Tab bar - Google style
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.all(4),
            dividerColor: Colors.transparent,
            labelColor: scheme.onPrimaryContainer,
            unselectedLabelColor: scheme.onSurfaceVariant,
            labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            unselectedLabelStyle: textTheme.labelLarge,
            tabs: const [
              Tab(text: 'Pharmacies'),
              Tab(text: 'Suppliers'),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _EnterpriseList(isProducers: false),
              _EnterpriseList(isProducers: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _EnterpriseList extends rp.ConsumerWidget {
  final bool isProducers;
  const _EnterpriseList({required this.isProducers});

  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    final async = ref.watch(isProducers ? producersProvider : shopsProvider);
    final favsAsync = ref.watch(favoritesProvider);
    final favOnly = ref.watch(discoverFavoritesOnlyProvider);
    
    return async.when(
      data: (items) {
        return favsAsync.when(
          data: (favs) {
            final filtered = favOnly
                ? items.where((e) => favs.shopIds.contains(e.id)).toList()
                : items;
            if (filtered.isEmpty) {
              return _EmptyState(
                icon: favOnly ? Icons.favorite_border_rounded : Icons.search_off_rounded,
                title: favOnly ? 'No favorites yet' : 'No results found',
                subtitle: favOnly 
                    ? 'Tap the heart icon on any pharmacy to save it here'
                    : 'Try adjusting your search terms',
                actionLabel: favOnly ? 'Browse all' : null,
                onAction: favOnly 
                    ? () => ref.read(discoverFavoritesOnlyProvider.notifier).toggle() 
                    : null,
              );
            }
            
            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                
                if (isWide) {
                  // Grid layout for tablets/desktop
                  final crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _EnterpriseCardWrapper(
                      e: filtered[index],
                      isProducer: isProducers,
                    ),
                  );
                }
                
                // List layout for phones
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _EnterpriseCardWrapper(
                    e: filtered[index],
                    isProducer: isProducers,
                  ),
                );
              },
            );
          },
          loading: () => const _ListSkeleton(),
          error: (e, _) => _ErrorState(
            message: 'Failed to load favorites',
            onRetry: () => ref.invalidate(favoritesProvider),
          ),
        );
      },
      loading: () => const _ListSkeleton(),
      error: (e, st) => _ErrorState(
        message: 'Something went wrong',
        onRetry: () => ref.invalidate(isProducers ? producersProvider : shopsProvider),
      ),
    );
  }
}

class _EnterpriseCardWrapper extends rp.ConsumerWidget {
  final Enterprise e;
  final bool isProducer;
  const _EnterpriseCardWrapper({required this.e, required this.isProducer});

  @override
  Widget build(BuildContext context, rp.WidgetRef ref) {
    return EnterpriseListItem(
      e: e,
      onTap: () => context.push(isProducer ? '/producers/${e.id}' : '/shops/${e.id}'),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => Container(
        height: 220,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // Banner skeleton
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
            ),
            // Content skeleton
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 150,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: scheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  
  const _EmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
