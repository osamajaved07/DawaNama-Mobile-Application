class Leaflet {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String productId;
  final String? productName;
  final String title;
  final String? version;
  final String language;
  final String fileUrl;
  final String fileType;
  final double? fileSizeKb;
  final String? description;
  final String? dosageInformation;
  final List<String>? sideEffects;
  final List<String>? contraindications;
  final List<String>? drugInteractions;
  final String? storageInstructions;
  final List<String>? warnings;
  final String status;
  final String? approvedBy;
  final DateTime? approvalDate;
  final DateTime? effectiveDate;
  final DateTime? expiryDate;
  final List<String>? tags;
  final List<String>? keywords;
  final int downloadCount;
  final DateTime? lastDownloadedAt;
  final bool isFeatured;

  Leaflet({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.productId,
    this.productName,
    required this.title,
    this.version,
    required this.language,
    required this.fileUrl,
    required this.fileType,
    this.fileSizeKb,
    this.description,
    this.dosageInformation,
    this.sideEffects,
    this.contraindications,
    this.drugInteractions,
    this.storageInstructions,
    this.warnings,
    required this.status,
    this.approvedBy,
    this.approvalDate,
    this.effectiveDate,
    this.expiryDate,
    this.tags,
    this.keywords,
    required this.downloadCount,
    this.lastDownloadedAt,
    required this.isFeatured,
  });

  factory Leaflet.fromJson(Map<String, dynamic> json) {
    return Leaflet(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      productId: json['product_id'],
      productName: json['products']?['name'] ?? 'Unknown Product',
      title: json['title'],
      version: json['version'],
      language: json['language'],
      fileUrl: json['file_url'],
      fileType: json['file_type'],
      fileSizeKb: json['file_size_kb']?.toDouble(),
      description: json['description'],
      dosageInformation: json['dosage_information'],
      sideEffects: (json['side_effects'] as List<dynamic>?)?.cast<String>(),
      contraindications: (json['contraindications'] as List<dynamic>?)
          ?.cast<String>(),
      drugInteractions: (json['drug_interactions'] as List<dynamic>?)
          ?.cast<String>(),
      storageInstructions: json['storage_instructions'],
      warnings: (json['warnings'] as List<dynamic>?)?.cast<String>(),
      status: json['status'],
      approvedBy: json['approved_by'],
      approvalDate: json['approval_date'] != null
          ? DateTime.parse(json['approval_date'])
          : null,
      effectiveDate: json['effective_date'] != null
          ? DateTime.parse(json['effective_date'])
          : null,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      keywords: (json['keywords'] as List<dynamic>?)?.cast<String>(),
      downloadCount: json['download_count'],
      lastDownloadedAt: json['last_downloaded_at'] != null
          ? DateTime.parse(json['last_downloaded_at'])
          : null,
      isFeatured: json['is_featured'],
    );
  }
}
