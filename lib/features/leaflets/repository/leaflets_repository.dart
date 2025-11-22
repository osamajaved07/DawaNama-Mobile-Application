import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaflet.dart';

class LeafletsRepository {
  final SupabaseClient _client;

  LeafletsRepository(this._client);

  Future<List<Leaflet>> fetchLeaflets() async {
    try {
      print('🔍 Fetching leaflets from database...');
      final data = await _client
          .from('leaflets')
          .select('*, products(name)')
          .order('created_at', ascending: false);

      print('📊 Raw data from database: $data');
      print('📦 Number of items: ${(data as List).length}');

      final leaflets = (data as List<dynamic>)
          .map((json) => Leaflet.fromJson(json))
          .toList();

      print('✅ Successfully mapped ${leaflets.length} leaflets');
      return leaflets;
    } catch (e) {
      print('❌ Error fetching leaflets: $e');
      throw Exception('Failed to fetch leaflets: $e');
    }
  }
}
