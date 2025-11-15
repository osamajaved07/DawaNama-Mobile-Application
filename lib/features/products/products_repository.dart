// ignore_for_file: unnecessary_cast

import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_model.dart';

class ProductsRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Fetch products with optional filters, search, sort, and limit
  Future<List<Product>> fetchProducts({
    String? category,
    String? search,
    String? status,
    String sort = 'name.asc',
    int limit = 200,
  }) async {
    try {
      // 1️⃣ Base query
      var query = supabase.from('products').select('*');

      // 2️⃣ Apply filters
      if (category != null && category.isNotEmpty && category != 'All') {
        query = query.eq('category', category);
      }

      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }

      if (search != null && search.isNotEmpty) {
        query = query.ilike('name', '%$search%');
      }

      // 3️⃣ Sorting
      final sortField = sort.split('.').first;
      final ascending = sort.endsWith('asc');
      final sortedQuery = query.order(sortField, ascending: ascending);

      // 4️⃣ Limit and execute
      final data = await sortedQuery.limit(limit);

      return (data as List)
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  /// Fetch single product by ID
  Future<Product?> fetchProductById(String id) async {
    try {
      final data = await supabase
          .from('products')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (data == null) return null;

      return Product.fromMap(data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch product: $e');
    }
  }

  /// Add new product
  Future<void> addProduct(Product product) async {
    try {
      await supabase.from('products').insert(product.toMap());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  /// Update existing product
  Future<void> updateProduct(Product product) async {
    try {
      await supabase
          .from('products')
          .update(product.toMap())
          .eq('id', product.id);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    try {
      await supabase.from('products').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
