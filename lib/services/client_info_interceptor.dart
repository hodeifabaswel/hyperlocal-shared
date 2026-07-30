import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Dio interceptor — technical-strategies.md §15.
/// Buat via [create()], panggil sekali di main().
class ClientInfoInterceptor extends Interceptor {
  final String _appVersion;
  final String _platform;
  final String _osVersion;
  final String _buildType;

  ClientInfoInterceptor._({
    required String appVersion,
    required String platform,
    required String osVersion,
    required String buildType,
  })  : _appVersion = appVersion,
        _platform = platform,
        _osVersion = osVersion,
        _buildType = buildType;

  static Future<ClientInfoInterceptor> create({required String buildType}) async {
    final pkg = await PackageInfo.fromPlatform();
    final device = DeviceInfoPlugin();
    String osVersion;
    if (Platform.isAndroid) {
      final info = await device.androidInfo;
      osVersion = info.version.release;
    } else if (Platform.isIOS) {
      final info = await device.iosInfo;
      osVersion = info.systemVersion;
    } else {
      osVersion = 'unknown';
    }
    return ClientInfoInterceptor._(
      appVersion: pkg.version,
      platform: Platform.isAndroid ? 'android' : 'ios',
      osVersion: osVersion,
      buildType: buildType,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-App-Version'] = _appVersion;
    options.headers['X-Platform'] = _platform;
    options.headers['X-OS-Version'] = _osVersion;
    options.headers['X-Build'] = _buildType;
    handler.next(options);
  }
}
