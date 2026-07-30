import 'package:flutter_test/flutter_test.dart';
import 'package:hyperlocal_shared/services/jwt_service.dart';

void main() {
  group('JwtService', () {
    // {"sub":"user-123","role":"customer","exp":9999999999}
    const validToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJzdWIiOiJ1c2VyLTEyMyIsInJvbGUiOiJjdXN0b21lciIsImV4cCI6OTk5OTk5OTk5OX0.'
        'fake-signature-for-testing';

    // {"sub":"user-456","role":"driver","exp":1000000000}
    const expiredToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJzdWIiOiJ1c2VyLTQ1NiIsInJvbGUiOiJkcml2ZXIiLCJleHAiOjEwMDAwMDAwMDB9.'
        'fake-signature-for-testing';

    test('isExpired returns false untuk token valid', () {
      expect(JwtService.isExpired(validToken), isFalse);
    });

    test('isExpired returns true untuk token expired', () {
      expect(JwtService.isExpired(expiredToken), isTrue);
    });

    test('isExpired returns true untuk token garbage', () {
      expect(JwtService.isExpired('not-a-jwt'), isTrue);
      expect(JwtService.isExpired(''), isTrue);
    });

    test('getRole extracts role', () {
      expect(JwtService.getRole(validToken), 'customer');
      expect(JwtService.getRole(expiredToken), 'driver');
    });

    test('getUserId extracts sub', () {
      expect(JwtService.getUserId(validToken), 'user-123');
    });

    test('decodeClaims returns null untuk token invalid', () {
      expect(JwtService.decodeClaims('garbage'), isNull);
    });
  });
}
