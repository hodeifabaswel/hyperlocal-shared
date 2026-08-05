/// Parsing deep link URI → route path.
///
/// PENTING — cara Dart/Flutter mem-parsing custom scheme URI:
///   hcust://order/abc-123/accepted
///   ─────  ─────  ───────────────
///   scheme  host    path (pathSegments)
///
/// Token PERTAMA setelah '://' selalu masuk ke uri.host, BUKAN uri.path.
/// Ini sesuai RFC 3986 §3.2 (authority) dan berlaku identik di dart:core Uri.

class DeepLinkResult {
  final String route;
  final bool recognized;
  const DeepLinkResult(this.route, {this.recognized = true});
  static const fallback = DeepLinkResult('/home', recognized: false);
}

typedef RouteResolver =
    DeepLinkResult Function(String host, List<String> segments);

class DeepLinkResolver {
  final String expectedScheme;
  final Map<String, RouteResolver> _resolvers;

  DeepLinkResolver({
    required this.expectedScheme,
    required Map<String, RouteResolver> resolvers,
  }) : _resolvers = resolvers;

  DeepLinkResult resolve(Uri uri) {
    if (uri.scheme != expectedScheme) {
      return DeepLinkResult.fallback;
    }

    final host = uri.host; // ← KUNCI DISPATCH, bukan pathSegments[0]
    final segments = uri.pathSegments;

    if (host.isEmpty) {
      return const DeepLinkResult('/home');
    }

    final resolver = _resolvers[host];
    if (resolver == null) {
      return DeepLinkResult.fallback;
    }

    return resolver(host, segments);
  }
}
