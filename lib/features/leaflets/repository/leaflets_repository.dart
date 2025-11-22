import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/leaflet.dart';

class LeafletsRepository {
  final SupabaseClient _client;

  LeafletsRepository(this._client);

  Future<List<Leaflet>> fetchLeaflets() async {
    try {
      final data = await _client
          .from('leaflets')
          .select()
          .order('created_at', ascending: false);

      return (data as List<dynamic>)
          .map((json) => Leaflet.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch leaflets: $e');
    }
  }
}
