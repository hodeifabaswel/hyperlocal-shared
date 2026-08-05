// test/services/permission_service_test.dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperlocal_shared/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart'; // ✅ FIX: Wajib import agar extension getter .isDenied resolve

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'checkPermissionStatus':
              // 0 = PermissionStatus.denied
              return 0;

            case 'requestPermissions':
              // return Map<int,int>, bukan bare int.
              final requested = List<int>.from(methodCall.arguments as List);
              return {for (final code in requested) code: 0}; // semua denied

            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('PermissionService', () {
    test(
      'requestLocation mengembalikan status denied saat izin ditolak',
      () async {
        final status = await PermissionService.requestLocation();
        expect(
          status.isDenied,
          isTrue,
        ); // ✅ .isDenied kini resolve dengan benar
      },
    );

    test(
      'requestCamera mengembalikan status denied saat izin ditolak',
      () async {
        final status = await PermissionService.requestCamera();
        expect(status.isDenied, isTrue);
      },
    );

    test(
      'requestNotification mengembalikan status denied saat izin ditolak',
      () async {
        final status = await PermissionService.requestNotification();
        expect(status.isDenied, isTrue);
      },
    );
  });
}
