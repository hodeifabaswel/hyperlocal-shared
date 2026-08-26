import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperlocal_shared/services/jwt_service.dart';

// Helper untuk generate token dinamis (exp relatif terhadap waktu test dijalankan)
String _generateDynamicToken(
  Duration expiryFromNow, {
  String role = 'customer',
  String sub = '123',
}) {
  final header = base64Url
      .encode(utf8.encode('{"alg":"none","typ":"JWT"}'))
      .replaceAll('=', '');
  final exp = DateTime.now().add(expiryFromNow).millisecondsSinceEpoch ~/ 1000;
  final payload = base64Url
      .encode(utf8.encode('{"sub":"$sub","role":"$role","exp":$exp}'))
      .replaceAll('=', '');
  return '$header.$payload.dummy_signature';
}

void main() {
  group('JwtService', () {
    test('isExpired returns false untuk token valid', () {
      expect(
        JwtService.isExpired(_generateDynamicToken(const Duration(hours: 1))),
        isFalse,
      );
    });

    test('isExpired returns true untuk token expired', () {
      expect(
        JwtService.isExpired(_generateDynamicToken(const Duration(hours: -1))),
        isTrue,
      );
    });

    test('isExpired returns true untuk token garbage', () {
      expect(JwtService.isExpired('not-a-jwt'), isTrue);
      expect(JwtService.isExpired(''), isTrue);
    });

    group('isExpiringSoon', () {
      test('true jika token akan expired dalam threshold', () {
        final token = _generateDynamicToken(const Duration(minutes: 3));
        expect(
          JwtService.isExpiringSoon(
            token,
            threshold: const Duration(minutes: 5),
          ),
          isTrue,
        );
      });
      test('false jika token masih lama', () {
        expect(
          JwtService.isExpiringSoon(
            _generateDynamicToken(const Duration(hours: 1)),
          ),
          isFalse,
        );
      });
      test('false jika token sudah expired', () {
        expect(
          JwtService.isExpiringSoon(
            _generateDynamicToken(const Duration(minutes: -10)),
          ),
          isFalse,
        );
      });
      test('false untuk token garbage', () {
        expect(JwtService.isExpiringSoon('invalid_token'), isFalse);
      });
    });

    test('getRole extracts role', () {
      expect(
        JwtService.getRole(
          _generateDynamicToken(Duration.zero, role: 'customer'),
        ),
        'customer',
      );
      expect(
        JwtService.getRole(
          _generateDynamicToken(Duration.zero, role: 'driver'),
        ),
        'driver',
      );
    });

    test('getUserId extracts sub', () {
      expect(
        JwtService.getUserId(
          _generateDynamicToken(Duration.zero, sub: 'user-123'),
        ),
        'user-123',
      );
    });

    test('decodeClaims returns null untuk token invalid', () {
      expect(JwtService.decodeClaims('garbage'), isNull);
    });
  });
}
