import 'package:flutter_test/flutter_test.dart';
import 'package:hyperlocal_shared/models/message_model.dart';

void main() {
  group('MessageModel.fromJson — format ERD', () {
    test('pesan dari customer', () {
      final json = {
        'id': 'msg-001',
        'order_id': 'order-001',
        'sender_type': 'customer',
        'customer_sender_id': 'cust-123',
        'driver_sender_id': null,
        'content': 'Halo, saya di depan ya',
        'message_type': 'text',
        'created_at': '2026-07-30T10:00:00Z',
      };
      final msg = MessageModel.fromJson(json);
      expect(msg.customerSenderId, 'cust-123');
      expect(msg.senderId, 'cust-123');
    });

    test('pesan dari driver', () {
      final json = {
        'id': 'msg-002',
        'order_id': 'order-001',
        'sender_type': 'driver',
        'customer_sender_id': null,
        'driver_sender_id': 'drv-456',
        'content': 'Oke, saya jalan sekarang',
        'message_type': 'text',
        'created_at': '2026-07-30T10:01:00Z',
      };
      final msg = MessageModel.fromJson(json);
      expect(msg.driverSenderId, 'drv-456');
      expect(msg.senderId, 'drv-456');
    });
  });

  group('MessageModel.fromJson — format fallback (sender_id)', () {
    test('backend kirim sender_id tunggal', () {
      final json = {
        'id': 'msg-003',
        'order_id': 'order-001',
        'sender_type': 'customer',
        'sender_id': 'cust-789',
        'content': 'Test fallback',
        'message_type': 'text',
        'created_at': '2026-07-30T10:02:00Z',
      };
      final msg = MessageModel.fromJson(json);
      expect(msg.customerSenderId, 'cust-789');
      expect(msg.senderId, 'cust-789');
    });
  });

  group('MessageAttachment.needsRefresh', () {
    test('true jika expires < 1 jam', () {
      final att = MessageAttachment(
        id: 'att-1',
        scanStatus: 'clean',
        presignedUrlExpiresAt:
            DateTime.now().toUtc().add(const Duration(minutes: 30)),
      );
      expect(att.needsRefresh, isTrue);
    });

    test('false jika expires > 1 jam', () {
      final att = MessageAttachment(
        id: 'att-2',
        scanStatus: 'clean',
        presignedUrlExpiresAt:
            DateTime.now().toUtc().add(const Duration(hours: 12)),
      );
      expect(att.needsRefresh, isFalse);
    });

    test('false jika null', () {
      final att = MessageAttachment(id: 'att-3', scanStatus: 'pending');
      expect(att.needsRefresh, isFalse);
    });
  });
}
