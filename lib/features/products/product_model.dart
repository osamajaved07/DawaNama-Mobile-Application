// lib/features/products/product_model.dart

class Product {
  final String id;
  final DateTime createdAt;
  final String name;
  final String sku;
  final String? description;
  final String? category;
  final String status;
  final String? unitOfMeasure;
  final String? packSize;
  final double? mrp;
  final double? tradePrice;
  final bool expiryDateHandling;
  final String? manufacturer;
  final List<String>? keyBenefits;
  final String? leafletsUrl;
  final String? imageUrl;
  final List<String>? targetSpecialty;

  Product({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.sku,
    this.description,
    this.category,
    required this.status,
    this.unitOfMeasure,
    this.packSize,
    this.mrp,
    this.tradePrice,
    required this.expiryDateHandling,
    this.manufacturer,
    this.keyBenefits,
    this.leafletsUrl,
    this.imageUrl,
    this.targetSpecialty,
  });

  /// --------------------------
  /// 💡 fromMap()
  /// Supabase row → Product
  /// --------------------------
  factory Product.fromMap(Map<String, dynamic> m) {
    return Product(
      id: m['id'],
      createdAt: DateTime.parse(m['created_at']),
      name: m['name'],
      sku: m['sku'],
      description: m['description'],
      category: m['category'],
      status: m['status'] ?? 'Active',
      unitOfMeasure: m['unit_of_measure'],
      packSize: m['pack_size'],
      mrp: m['mrp'] != null ? (m['mrp'] as num).toDouble() : null,
      tradePrice: m['trade_price'] != null
          ? (m['trade_price'] as num).toDouble()
          : null,
      expiryDateHandling: m['expiry_date_handling'] ?? false,
      manufacturer: m['manufacturer'],
      keyBenefits: (m['key_benefits'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      leafletsUrl: m['leaflets_url'],
      imageUrl: m['image_url'],
      targetSpecialty: (m['target_specialty'] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  /// --------------------------
  /// 💡 toMap()
  /// Product → Supabase Insert/Update
  /// --------------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'sku': sku,
      'description': description,
      'category': category,
      'status': status,
      'unit_of_measure': unitOfMeasure,
      'pack_size': packSize,
      'mrp': mrp,
      'trade_price': tradePrice,
      'expiry_date_handling': expiryDateHandling,
      'manufacturer': manufacturer,
      'key_benefits': keyBenefits,
      'leaflets_url': leafletsUrl,
      'image_url': imageUrl,
      'target_specialty': targetSpecialty,
    };
  }
}
