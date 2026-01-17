import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:sellingapp/core/providers.dart';
import 'package:sellingapp/models/enterprise.dart';

/// Home screen data providers
/// These are intentionally lightweight and UI-focused. They reuse the
/// existing ShopRepository to surface a few preview lists. In a real setup
/// these would call category/geo-aware endpoints.

final homePopularListingsProvider = rp.FutureProvider<List<Enterprise>>((ref) async {
  final repo = ref.watch(shopRepositoryProvider);
  // Use shops as a stand-in for "popular" listings. Limit to ~10.
  final items = await repo.listShops();
  return items.take(10).toList();
});

final homeFeaturedListingsProvider = rp.FutureProvider<List<Enterprise>>((ref) async {
  final repo = ref.watch(shopRepositoryProvider);
  // Use producers as a stand-in for featured; limit to 6.
  final items = await repo.listProducers();
  return items.take(6).toList();
});

/// Buckets for urgency summary. When expiry information is unavailable in the
/// dataset, we provide a simple proportional fallback based on the available
/// count so the UI remains informative.
class UrgencyCounts {
  final int under2h;
  final int under8h;
  final int under24h;
  final int under48h;
  const UrgencyCounts({required this.under2h, required this.under8h, required this.under24h, required this.under48h});
}

final homeUrgencyCountsProvider = rp.FutureProvider<UrgencyCounts>((ref) async {
  final list = await ref.watch(homePopularListingsProvider.future);
  final n = list.length;
  // Simple fallback distribution
  final u2 = (n * 0.15).round();
  final u8 = (n * 0.25).round();
  final u24 = (n * 0.35).round();
  final u48 = n - (u2 + u8 + u24);
  return UrgencyCounts(under2h: u2, under8h: u8, under24h: u24, under48h: u48);
});
