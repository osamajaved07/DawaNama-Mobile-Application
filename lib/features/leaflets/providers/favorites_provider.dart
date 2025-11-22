// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageKey = 'favorite_leaflet_ids';

/// Provider for managing favorite leaflet IDs using SharedPreferences
final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(() {
  return FavoritesNotifier();
});

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    _loadFavorites();
    return {};
  }

  /// Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList(_storageKey) ?? [];
      state = Set.from(favoriteIds);
      print('📚 Loaded ${favoriteIds.length} favorite leaflets');
    } catch (e) {
      print('❌ Error loading favorites: $e');
    }
  }

  /// Toggle favorite status for a leaflet ID
  Future<void> toggleFavorite(String leafletId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newState = Set<String>.from(state);

      if (newState.contains(leafletId)) {
        newState.remove(leafletId);
        print('❤️ Removed $leafletId from favorites');
      } else {
        newState.add(leafletId);
        print('❤️ Added $leafletId to favorites');
      }

      state = newState;
      await prefs.setStringList(_storageKey, newState.toList());
    } catch (e) {
      print('❌ Error toggling favorite: $e');
    }
  }

  /// Check if a leaflet is favorite
  bool isFavorite(String leafletId) {
    return state.contains(leafletId);
  }

  /// Get all favorite IDs
  Set<String> getFavoriteIds() {
    return Set.from(state);
  }
}
