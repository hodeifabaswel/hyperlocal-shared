import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperlocal_shared/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );

  // Helper eksplisit untuk mapping PermissionStatus ke integer MethodChannel.
  // Nilai integer ini fix mengikuti definisi native (Android/iOS) dari permission_handler.
  int _getStatusValue(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
        return 0;
      case PermissionStatus.granted:
        return 1;
      case PermissionStatus.restricted:
        return 2;
      case PermissionStatus.limited:
        return 3;
      case PermissionStatus.permanentlyDenied:
        return 4;
      case PermissionStatus.provisional:
        return 5;
    }
  }

  void setupMock(PermissionStatus mockedStatus) {
    // Gunakan helper lokal alih-alih .value
    final code = _getStatusValue(mockedStatus);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          if (call.method == 'checkPermissionStatus') {
            return code;
          } else if (call.method == 'requestPermissions') {
            final permissions = List<int>.from(call.arguments as List);
            return {for (final p in permissions) p: code};
          } else if (call.method == 'checkServiceStatus') {
            return 0; // enabled
          }
          return null;
        });
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('PermissionService - Denied Scenarios', () {
    setUp(() => setupMock(PermissionStatus.denied));
    test(
      'requestLocation returns denied',
      () async =>
          expect((await PermissionService.requestLocation()).isDenied, isTrue),
    );
    test(
      'requestCamera returns denied',
      () async =>
          expect((await PermissionService.requestCamera()).isDenied, isTrue),
    );
    test(
      'requestNotification returns denied',
      () async => expect(
        (await PermissionService.requestNotification()).isDenied,
        isTrue,
      ),
    );
  });

  group('PermissionService - Granted Scenarios', () {
    setUp(() => setupMock(PermissionStatus.granted));
    test(
      'requestLocation returns granted',
      () async =>
          expect((await PermissionService.requestLocation()).isGranted, isTrue),
    );
    test(
      'requestCamera returns granted',
      () async =>
          expect((await PermissionService.requestCamera()).isGranted, isTrue),
    );
    test(
      'requestNotification returns granted',
      () async => expect(
        (await PermissionService.requestNotification()).isGranted,
        isTrue,
      ),
    );
  });

  group('PermissionService - Background Location (Mitra App)', () {
    test('requestLocationBackground returns granted', () async {
      setupMock(PermissionStatus.granted);
      expect(
        (await PermissionService.requestLocationBackground()).isGranted,
        isTrue,
      );
    });
  });
}
