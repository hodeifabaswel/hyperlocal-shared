import 'package:permission_handler/permission_handler.dart';

/// Handler permission — technical-strategies.md §14 & §19.
class PermissionService {
  static Future<PermissionStatus> requestLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      status = await Permission.locationWhenInUse.request();
    }
    return status;
  }

  static Future<PermissionStatus> requestCamera() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    return status;
  }

  static Future<PermissionStatus> requestNotification() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      status = await Permission.notification.request();
    }
    return status;
  }

  /// WAJIB untuk Mitra App (technical-strategies.md §19) agar WS tracking tetap hidup.
  static Future<PermissionStatus> requestLocationBackground() async {
    var status = await Permission.locationAlways.status;
    if (status.isDenied) {
      status = await Permission.locationAlways.request();
    }
    return status;
  }

  /// Varian "baca status saja" tanpa memicu dialog OS (technical-strategies.md §14).
  /// Dipakai saat app resume ke foreground.
  static Future<PermissionStatus> checkLocationStatus() async =>
      await Permission.locationWhenInUse.status;
  static Future<PermissionStatus> checkLocationBackgroundStatus() async =>
      await Permission.locationAlways.status;
  static Future<PermissionStatus> checkCameraStatus() async =>
      await Permission.camera.status;
  static Future<PermissionStatus> checkNotificationStatus() async =>
      await Permission.notification.status;

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
