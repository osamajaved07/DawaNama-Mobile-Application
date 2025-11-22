// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaflet.dart';
import '../repository/leaflets_repository.dart';

final leafletsProvider = FutureProvider<List<Leaflet>>((ref) async {
  final repository = ref.watch(leafletsRepositoryProvider);
  final leaflets = await repository.fetchLeaflets();
  print('✅ Leaflets fetched: ${leaflets.length} leaflets found');
  return leaflets;
});

final leafletsRepositoryProvider = Provider<LeafletsRepository>((ref) {
  final client = Supabase.instance.client;
  return LeafletsRepository(client);
});

// Get distinct products for filter dropdown
final distinctProductsProvider = FutureProvider<List<String>>((ref) async {
  final leaflets = await ref.watch(leafletsProvider.future);
  final products = <String>{};
  for (final leaflet in leaflets) {
    if (leaflet.productName != null && leaflet.productName!.isNotEmpty) {
      products.add(leaflet.productName!);
    }
  }
  return products.toList()..sort();
});

// Get distinct languages for filter dropdown
final distinctLanguagesProvider = FutureProvider<List<String>>((ref) async {
  final leaflets = await ref.watch(leafletsProvider.future);
  final languages = <String>{};
  for (final leaflet in leaflets) {
    languages.add(leaflet.language);
  }
  return languages.toList()..sort();
});

// Get distinct statuses for filter dropdown
final distinctStatusesProvider = FutureProvider<List<String>>((ref) async {
  final leaflets = await ref.watch(leafletsProvider.future);
  final statuses = <String>{};
  for (final leaflet in leaflets) {
    statuses.add(leaflet.status);
  }
  return statuses.toList()..sort();
});

// Provider to trigger refresh manually
final leafletsRefreshProvider = Provider<Future<List<Leaflet>> Function()>((
  ref,
) {
  return () async {
    print('🔄 Manual refresh triggered');
    ref.invalidate(leafletsProvider);
    return ref.read(leafletsProvider.future);
  };
});
