import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdService {
  final DeviceInfoPlugin _deviceInfo;
  String? _cachedId;

  DeviceIdService({DeviceInfoPlugin? deviceInfo})
      : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    if (_cachedId != null) return _cachedId!;

    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      _cachedId = info.id;
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      _cachedId = info.identifierForVendor ?? 'unknown-ios';
    } else {
      _cachedId = 'unknown-platform';
    }

    return _cachedId!;
  }
}
