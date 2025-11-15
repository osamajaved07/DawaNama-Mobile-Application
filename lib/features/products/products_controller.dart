import 'package:dawanama/features/products/products_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'product_model.dart';

final productsControllerProvider =
    StateNotifierProvider<ProductsController, AsyncValue<List<Product>>>(
      (ref) => ProductsController(ref),
    );

class ProductsController extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;

  String category = 'All';
  String search = '';
  String sort = 'name.asc';
  String? status;

  ProductsController(this.ref) : super(const AsyncLoading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      state = const AsyncLoading();

      final repo = ref.read(productsRepositoryProvider);

      final products = await repo.fetchProducts(
        category: category,
        search: search,
        sort: sort,
        status: status,
      );

      state = AsyncData(products);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void updateCategory(String c) {
    category = c;
    loadProducts();
  }

  void updateSearch(String v) {
    search = v;
    loadProducts();
  }

  void updateSort(String v) {
    sort = v;
    loadProducts();
  }

  void updateStatus(String? v) {
    status = v;
    loadProducts();
  }
}
