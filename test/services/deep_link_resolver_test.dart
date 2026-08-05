import 'package:flutter_test/flutter_test.dart';
import 'package:hyperlocal_shared/services/deep_link_resolver.dart';

void main() {
  group('URI parsing fundamental (RFC 3986)', () {
    test('token pertama setelah scheme:// masuk ke host, bukan path', () {
      final u = Uri.parse('hcust://order/abc-123/accepted');
      expect(u.scheme, 'hcust');
      expect(u.host, 'order');
      expect(u.pathSegments, ['abc-123', 'accepted']);
    });

    test('single-token URI → host saja, segments kosong', () {
      final u = Uri.parse('hcust://home');
      expect(u.host, 'home');
      expect(u.pathSegments, isEmpty);
    });

    test('URI tanpa token → host kosong', () {
      final u = Uri.parse('hcust://');
      expect(u.host, isEmpty);
      expect(u.pathSegments, isEmpty);
    });
  });

  group('DeepLinkResolver — Customer (hcust://)', () {
    late DeepLinkResolver resolver;

    setUp(() {
      resolver = DeepLinkResolver(
        expectedScheme: 'hcust',
        resolvers: {
          'home': (host, segments) => const DeepLinkResult('/home'),
          'order': (host, segments) {
            if (segments.isEmpty) return const DeepLinkResult('/home');
            final orderId = segments[0];
            if (segments.length >= 2 && segments[1] == 'accepted') {
              return DeepLinkResult('/tracking/$orderId');
            }
            if (segments.length >= 2 && segments[1] == 'rate') {
              return DeepLinkResult('/order/$orderId/rate');
            }
            return DeepLinkResult('/tracking/$orderId');
          },
          'chat': (host, segments) {
            if (segments.isEmpty) return const DeepLinkResult('/home');
            return DeepLinkResult('/chat/${segments[0]}');
          },
        },
      );
    });

    test('hcust://home → /home', () {
      expect(resolver.resolve(Uri.parse('hcust://home')).route, '/home');
    });

    test('hcust://order/abc-123/accepted → /tracking/abc-123', () {
      expect(
        resolver.resolve(Uri.parse('hcust://order/abc-123/accepted')).route,
        '/tracking/abc-123',
      );
    });

    test('hcust://order/abc-123/rate → /order/abc-123/rate', () {
      expect(
        resolver.resolve(Uri.parse('hcust://order/abc-123/rate')).route,
        '/order/abc-123/rate',
      );
    });

    test('hcust://chat/xyz-789 → /chat/xyz-789', () {
      expect(
        resolver.resolve(Uri.parse('hcust://chat/xyz-789')).route,
        '/chat/xyz-789',
      );
    });

    test('hcust://chat (tanpa id) → /home fallback', () {
      expect(resolver.resolve(Uri.parse('hcust://chat')).route, '/home');
    });

    test('scheme salah → fallback', () {
      final result = resolver.resolve(Uri.parse('hmitra://home'));
      expect(result.recognized, isFalse);
    });

    test('app:// scheme lama → fallback', () {
      expect(resolver.resolve(Uri.parse('app://home')).recognized, isFalse);
    });
  });

  group('DeepLinkResolver — Mitra (hmitra://)', () {
    late DeepLinkResolver resolver;

    setUp(() {
      resolver = DeepLinkResolver(
        expectedScheme: 'hmitra',
        resolvers: {
          'home': (host, segments) => const DeepLinkResult('/home'),
          'order': (host, segments) => const DeepLinkResult('/home'),
          'chat': (host, segments) {
            if (segments.isEmpty) return const DeepLinkResult('/home');
            return DeepLinkResult('/navigation/chat/${segments[0]}');
          },
          'wallet': (host, segments) => const DeepLinkResult('/wallet'),
          'verification': (host, segments) =>
              const DeepLinkResult('/onboarding/verification-rejected'),
        },
      );
    });

    test('hmitra://home → /home', () {
      expect(resolver.resolve(Uri.parse('hmitra://home')).route, '/home');
    });

    test('hmitra://order/incoming → /home', () {
      expect(
        resolver.resolve(Uri.parse('hmitra://order/incoming')).route,
        '/home',
      );
    });

    test('hmitra://wallet → /wallet', () {
      expect(resolver.resolve(Uri.parse('hmitra://wallet')).route, '/wallet');
    });

    test('hmitra://verification → /onboarding/verification-rejected', () {
      expect(
        resolver.resolve(Uri.parse('hmitra://verification')).route,
        '/onboarding/verification-rejected',
      );
    });

    test('hcust:// di resolver mitra → fallback', () {
      expect(
        resolver.resolve(Uri.parse('hcust://home')).recognized,
        isFalse,
      );
    });
  });
}
