import 'package:jwt_decoder/jwt_decoder.dart';

/// Utilitas generik untuk decode payload JWT secara lokal tanpa verifikasi signature.
/// Dipakai oleh Dio Interceptor (REST) dan handler WebSocket (technical-strategies.md §12).
class JwtService {
  /// Mengecek apakah token sudah kedaluwarsa.
  /// Mengembalikan `true` jika token sudah expired ATAU jika token tidak valid (fail-safe).
  static bool isExpired(String token, {Duration buffer = Duration.zero}) {
    try {
      final expiry = JwtDecoder.getExpirationDate(token);
      return DateTime.now().add(buffer).isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  /// Mengecek apakah token akan kedaluwarsa dalam waktu dekat (default: 5 menit).
  /// Mengembalikan `true` HANYA jika token masih valid TETAPI akan expired dalam [threshold].
  /// Dipakai untuk memicu proactive silent refresh di Dio Interceptor.
  static bool isExpiringSoon(String token, {Duration threshold = const Duration(minutes: 5)}) {
    return isExpired(token, buffer: threshold) && !isExpired(token);
  }

  /// Mengekstrak klaim JWT. Mengembalikan null jika format token salah.
  static Map<String, dynamic>? decodeClaims(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (_) {
      return null;
    }
  }

  static String? getRole(String token) => decodeClaims(token)?['role'] as String?;
  static String? getUserId(String token) => decodeClaims(token)?['sub'] as String?;
}
