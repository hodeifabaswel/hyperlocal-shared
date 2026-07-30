import 'package:permission_handler/permission_handler.dart';

/// Handler permission — technical-strategies.md §14.
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

  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
