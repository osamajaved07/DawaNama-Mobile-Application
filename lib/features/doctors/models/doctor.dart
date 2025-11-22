class Doctor {
  final String id;
  final String name;
  final String? email;
  final String? specialty;
  final String? city;
  final String clinicAddress;
  final int? phone;
  final String? mrsId;

  Doctor({
    required this.id,
    required this.name,
    this.email,
    this.specialty,
    this.city,
    required this.clinicAddress,
    this.phone,
    this.mrsId,
  });

  /// Create Doctor from JSON (Supabase response)
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      specialty: json['specialty'] as String?,
      city: json['city'] as String?,
      clinicAddress: json['clinic_address'] as String,
      phone: json['phone'] as int?,
      mrsId: json['mrs_id'] as String?,
    );
  }

  /// Convert Doctor to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'specialty': specialty,
    'city': city,
    'clinic_address': clinicAddress,
    'phone': phone,
    'mrs_id': mrsId,
  };

  /// Copy with method for creating modified copies
  Doctor copyWith({
    String? id,
    String? name,
    String? email,
    String? specialty,
    String? city,
    String? clinicAddress,
    int? phone,
    String? mrsId,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      specialty: specialty ?? this.specialty,
      city: city ?? this.city,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      phone: phone ?? this.phone,
      mrsId: mrsId ?? this.mrsId,
    );
  }

  @override
  String toString() => 'Doctor(id: $id, name: $name, specialty: $specialty)';
}
