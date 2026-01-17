import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:sellingapp/core/providers.dart';
import 'package:sellingapp/models/enterprise.dart';

/// Query state for urgency listings screen
final urgencyQueryProvider = rp.StateProvider.autoDispose<String>((ref) => '');

/// Selected sort option
enum UrgencySort { distance, bestValue, soonest, cheapest }
final urgencySortProvider = rp.StateProvider.autoDispose<UrgencySort>((ref) => UrgencySort.soonest);

/// Urgency listings based on a time window in hours.
/// If backend supports expires_within_hours, it should be applied in the data source.
/// For now, we fetch a generic list and locally sort by ordersCloseAt when requested.
final urgencyListingsProvider = rp.FutureProvider.autoDispose.family<List<Enterprise>, int>((ref, windowHours) async {
  final repo = ref.watch(shopRepositoryProvider);
  final q = ref.watch(urgencyQueryProvider);
  // Use shops as base dataset; in a real backend, pass `expires_within_hours=windowHours`
  var items = await repo.listShops(query: q);
  // Optionally filter to mimic urgency window using ordersCloseAt when present
  final now = DateTime.now();
  items = items.where((e) {
    final end = e.ordersCloseAt;
    if (end == null) return true; // show non-expiring too; urgency is broader than expiry
    final diff = end.difference(now).inHours;
    return diff <= windowHours && diff >= -1; // include those closing soon; avoid long-expired
  }).toList();

  final sort = ref.watch(urgencySortProvider);
  switch (sort) {
    case UrgencySort.soonest:
      items.sort((a, b) {
        final aEnd = a.ordersCloseAt;
        final bEnd = b.ordersCloseAt;
        if (aEnd == null && bEnd == null) return 0;
        if (aEnd == null) return 1;
        if (bEnd == null) return -1;
        return aEnd.compareTo(bEnd);
      });
      break;
    case UrgencySort.distance:
    case UrgencySort.bestValue:
    case UrgencySort.cheapest:
      // Not enough data in mock to sort meaningfully; keep current ordering
      break;
  }
  return items;
});
