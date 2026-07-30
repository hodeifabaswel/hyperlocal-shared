/// Model mitra — dipakai Customer App (C3) & Mitra App (profil).
///
/// Nilai vehicleType mengikuti ENUM `vehicle_type` di erd.md §4:
/// 'BICYCLE' | 'MOTORCYCLE' | 'ON_FOOT' (UPPERCASE, case-sensitive).
class DriverModel {
  final String id;
  final String name;
  final String? photoUrl;
  final String vehicleType;
  final String status;
  final String? bankName;
  final String? bankAccountLast4;
  final String? bankAccountName;
  final double? rating;

  const DriverModel({
    this.id = '',
    required this.name,
    this.photoUrl,
    this.vehicleType = 'BICYCLE',
    this.status = 'OFFLINE',
    this.bankName,
    this.bankAccountLast4,
    this.bankAccountName,
    this.rating,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      photoUrl: json['photo_url'] as String?,
      vehicleType: json['vehicle_type'] as String? ?? 'BICYCLE',
      status: json['status'] as String? ?? 'OFFLINE',
      bankName: json['bank_name'] as String?,
      bankAccountLast4: json['bank_account_last4'] as String?,
      bankAccountName: json['bank_account_name'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  /// Helper display — blueprint-ui.md C3: "Sepeda • 0.3km • tiba 3 menit"
  String get vehicleTypeLabel {
    switch (vehicleType) {
      case 'BICYCLE':
        return 'Sepeda';
      case 'ON_FOOT':
        return 'Jalan Kaki';
      case 'MOTORCYCLE':
        return 'Motor';
      default:
        return vehicleType;
    }
  }
}
