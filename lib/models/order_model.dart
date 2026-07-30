import 'package:hyperlocal_shared/models/driver_model.dart';
import 'package:hyperlocal_shared/models/customer_model.dart';

/// Model order — UNION dari response §7 role=customer dan role=driver.
/// Field yang tidak ada di salah satu response akan null.
class OrderModel {
  final String id;
  final String status;

  // Finansial — ERD: DECIMAL(12,2), cast via num
  final int fare;
  final int platformFee;

  final String? driverId;
  final String? customerId;

  // Nested objects (role-specific, §7)
  final DriverModel? driver;
  final CustomerModel? customer;
  final int? etaMinutes;

  // Alamat & koordinat
  final String? pickupAddress;
  final String? dropoffAddress;
  final GeoPoint? pickupPoint;
  final GeoPoint? dropoffPoint;
  final String? polyline;
  final int? distanceMeters;

  // Rating
  final int? rating;
  final String? ratingComment;

  // Catatan
  /// ⚠️ Ada di response §7 tapi TIDAK ADA kolom di erd.md v2.8.
  /// TODO(erd-fix): Tunggu kolom orders.note ditambahkan ke ERD + migrasi.
  final String? note;
  final String? finishNote;
  final String? customerPaymentMethod;

  // Timestamps — semua nullable (tidak ada di kedua contoh §7)
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    required this.status,
    required this.fare,
    this.platformFee = 0,
    this.driverId,
    this.customerId,
    this.driver,
    this.customer,
    this.etaMinutes,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupPoint,
    this.dropoffPoint,
    this.polyline,
    this.distanceMeters,
    this.rating,
    this.ratingComment,
    this.note,
    this.finishNote,
    this.customerPaymentMethod,
    this.startedAt,
    this.completedAt,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      status: json['status'] as String,
      fare: (json['fare'] as num).toInt(),
      platformFee: (json['platform_fee'] as num?)?.toInt() ?? 0,
      driverId: json['driver_id'] as String?,
      customerId: json['customer_id'] as String?,
      driver: json['driver'] != null
          ? DriverModel.fromJson(json['driver'] as Map<String, dynamic>)
          : null,
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      etaMinutes: (json['eta_minutes'] as num?)?.toInt(),
      pickupAddress: json['pickup_address'] as String?,
      dropoffAddress: json['dropoff_address'] as String?,
      pickupPoint: json['pickup_point'] != null
          ? GeoPoint.fromJson(json['pickup_point'] as Map<String, dynamic>)
          : null,
      dropoffPoint: json['dropoff_point'] != null
          ? GeoPoint.fromJson(json['dropoff_point'] as Map<String, dynamic>)
          : null,
      polyline: json['polyline'] as String?,
      distanceMeters: (json['distance_meters'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toInt(),
      ratingComment: json['rating_comment'] as String?,
      note: json['note'] as String?,
      finishNote: json['finish_note'] as String?,
      customerPaymentMethod: json['customer_payment_method'] as String?,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'fare': fare,
        'platform_fee': platformFee,
        'driver_id': driverId,
        'customer_id': customerId,
        if (driver != null)
          'driver': {
            'name': driver!.name,
            'photo_url': driver!.photoUrl,
            'vehicle_type': driver!.vehicleType,
            'bank_name': driver!.bankName,
            'bank_account_last4': driver!.bankAccountLast4,
            'bank_account_name': driver!.bankAccountName,
          },
        if (customer != null)
          'customer': {
            'name': customer!.name,
            'phone_formatted': customer!.phoneFormatted,
          },
        'eta_minutes': etaMinutes,
        'pickup_address': pickupAddress,
        'dropoff_address': dropoffAddress,
        if (pickupPoint != null) 'pickup_point': pickupPoint!.toJson(),
        if (dropoffPoint != null) 'dropoff_point': dropoffPoint!.toJson(),
        'polyline': polyline,
        'distance_meters': distanceMeters,
        'rating': rating,
        'rating_comment': ratingComment,
        'note': note,
        'finish_note': finishNote,
        'customer_payment_method': customerPaymentMethod,
        'started_at': startedAt?.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
      };
}

class GeoPoint {
  final double lat;
  final double lng;

  const GeoPoint({required this.lat, required this.lng});

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}
