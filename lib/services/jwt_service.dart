import 'package:jwt_decoder/jwt_decoder.dart';

/// Parse & cek expiry JWT — technical-strategies.md §12.
class JwtService {
  static bool isExpired(String token, {Duration buffer = Duration.zero}) {
    try {
      final expiry = JwtDecoder.getExpirationDate(token);
      return DateTime.now().add(buffer).isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  static Map<String, dynamic>? decodeClaims(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (_) {
      return null;
    }
  }

  static String? getRole(String token) {
    return decodeClaims(token)?['role'] as String?;
  }

  static String? getUserId(String token) {
    return decodeClaims(token)?['sub'] as String?;
  }
}
