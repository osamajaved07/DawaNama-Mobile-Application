import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_repository.dart';
import 'product_model.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepository();
});

// Search query provider
final productsSearchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(() {
      return SearchQueryNotifier();
    });

class SearchQueryNotifier extends Notifier<String> {
  @override
  build() => '';

  void set(String value) => state = value;
}

// Selected category provider
final productsSelectedCategoryProvider =
    NotifierProvider<CategoryNotifier, String>(() {
      return CategoryNotifier();
    });

class CategoryNotifier extends Notifier<String> {
  @override
  build() => 'All';

  void set(String value) => state = value;
}

// Sort provider
final productsSortProvider = NotifierProvider<SortNotifier, String>(() {
  return SortNotifier();
});

class SortNotifier extends Notifier<String> {
  @override
  build() => 'name.asc';

  void set(String value) => state = value;
}

// Status filter provider
final productsStatusFilterProvider = NotifierProvider<StatusNotifier, String?>(
  () {
    return StatusNotifier();
  },
);

class StatusNotifier extends Notifier<String?> {
  @override
  build() => null;

  void set(String? value) => state = value;
}

// Main products list provider that combines all filters
final productsListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productsRepositoryProvider);
  final search = ref.watch(productsSearchQueryProvider);
  final category = ref.watch(productsSelectedCategoryProvider);
  final sort = ref.watch(productsSortProvider);
  final status = ref.watch(productsStatusFilterProvider);

  return repository.fetchProducts(
    category: category == 'All' ? null : category,
    search: search.isEmpty ? null : search,
    status: status,
    sort: sort,
    limit: 500,
  );
});
