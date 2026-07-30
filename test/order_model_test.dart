import 'package:flutter_test/flutter_test.dart';
import 'package:hyperlocal_shared/models/order_model.dart';

void main() {
  group('OrderModel.fromJson', () {
    test('parse response role=customer (§7) — persis dokumentasi', () {
      final json = {
        'id': 'order-001',
        'status': 'ACCEPTED',
        'fare': 6000,
        'driver': {
          'name': 'Budi',
          'photo_url': 'https://example.com/budi.jpg',
          'vehicle_type': 'BICYCLE',
          'bank_name': 'BCA',
          'bank_account_last4': '1234',
          'bank_account_name': 'Budi Santoso',
        },
        'eta_minutes': 5,
      };

      final order = OrderModel.fromJson(json);

      expect(order.fare, 6000);
      expect(order.platformFee, 0);
      expect(order.driver, isNotNull);
      expect(order.driver!.id, '');
      expect(order.driver!.name, 'Budi');
      expect(order.driver!.vehicleType, 'BICYCLE');
      expect(order.driver!.vehicleTypeLabel, 'Sepeda');
      expect(order.etaMinutes, 5);
      expect(order.customer, isNull);
      expect(order.createdAt, isNull);
    });

    test('parse response role=driver (§7) — persis dokumentasi', () {
      final json = {
        'id': 'order-002',
        'status': 'ACCEPTED',
        'fare': 6000,
        'platform_fee': 1000,
        'customer': {
          'name': 'Andi',
          'phone_formatted': '0812-****-5678',
        },
        'pickup_address': 'Jl. Sudirman No. 1',
        'dropoff_address': 'Jl. Thamrin No. 5',
        'pickup_point': {'lat': -6.21, 'lng': 106.84},
        'dropoff_point': {'lat': -6.19, 'lng': 106.82},
        'note': 'Titip ke satpam kalau tidak ada',
      };

      final order = OrderModel.fromJson(json);

      expect(order.customer!.id, '');
      expect(order.customer!.name, 'Andi');
      expect(order.platformFee, 1000);
      expect(order.pickupPoint!.lat, -6.21);
      expect(order.note, 'Titip ke satpam kalau tidak ada');
      expect(order.driver, isNull);
      expect(order.createdAt, isNull);
    });

    test('fare via num cast — handle 6000 dan 6000.00', () {
      final jsonInt = {'id': 'o1', 'status': 'SEARCHING', 'fare': 6000};
      final jsonDouble = {'id': 'o2', 'status': 'SEARCHING', 'fare': 6000.00};
      expect(OrderModel.fromJson(jsonInt).fare, 6000);
      expect(OrderModel.fromJson(jsonDouble).fare, 6000);
    });

    test('fare tanpa fallback — throw jika absen', () {
      final json = {'id': 'o3', 'status': 'SEARCHING'};
      expect(() => OrderModel.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('platformFee fallback ke 0 saat absen', () {
      final json = {'id': 'o4', 'status': 'ACCEPTED', 'fare': 6000};
      expect(OrderModel.fromJson(json).platformFee, 0);
    });

    test('driver.id dan customer.id fallback ke empty string', () {
      final jsonC = {
        'id': 'o5', 'status': 'ACCEPTED', 'fare': 6000,
        'customer': {'name': 'Siti'},
      };
      final jsonD = {
        'id': 'o6', 'status': 'ACCEPTED', 'fare': 6000,
        'driver': {'name': 'Agus'},
      };
      expect(OrderModel.fromJson(jsonC).customer!.id, '');
      expect(OrderModel.fromJson(jsonD).driver!.id, '');
    });

    test('createdAt nullable — tidak throw saat absen', () {
      final json = {'id': 'o7', 'status': 'SEARCHING', 'fare': 6000};
      expect(OrderModel.fromJson(json).createdAt, isNull);
    });

    test('toJson round-trip', () {
      final json = {
        'id': 'o9',
        'status': 'COMPLETED',
        'fare': 6000,
        'platform_fee': 1000,
        'rating': 5,
        'rating_comment': 'Cepat banget!',
        'finish_note': 'Dititip ke satpam',
        'created_at': '2026-07-30T09:00:00Z',
        'completed_at': '2026-07-30T09:30:00Z',
      };
      final order = OrderModel.fromJson(json);
      final restored = OrderModel.fromJson(order.toJson());
      expect(restored.id, order.id);
      expect(restored.fare, order.fare);
      expect(restored.rating, 5);
      expect(restored.finishNote, 'Dititip ke satpam');
      expect(restored.createdAt, order.createdAt);
    });
  });
}
