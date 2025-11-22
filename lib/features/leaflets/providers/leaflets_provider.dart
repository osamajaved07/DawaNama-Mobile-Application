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
