import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Widget peta OSM — self-hosted, BUKAN Google Maps (blueprint.md §1).
class HyperlocalMapWidget extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final void Function(LatLng)? onTap;
  final String tileUrl;

  /// WAJIB di-pass eksplisit — tidak ada default yang masuk akal
  /// karena Customer ('com.hyperlocal.customer') dan Mitra
  /// ('com.hyperlocal.mitra') HARUS berbeda.
  final String userAgentPackageName;

  const HyperlocalMapWidget({
    super.key,
    required this.center,
    this.zoom = 15.0,
    this.markers = const [],
    this.polylines = const [],
    this.onTap,
    this.tileUrl = 'http://tile-server:8080/{z}/{x}/{y}.png',
    required this.userAgentPackageName,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        onTap: onTap != null ? (_, point) => onTap!(point) : null,
      ),
      children: [
        TileLayer(
          urlTemplate: tileUrl,
          userAgentPackageName: userAgentPackageName,
        ),
        PolylineLayer(polylines: polylines),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
