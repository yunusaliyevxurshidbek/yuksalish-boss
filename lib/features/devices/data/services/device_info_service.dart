import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/my_shared_preferences.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/device_info.dart';

/// Service for gathering device information and managing persistent device ID.
///
/// Uses `device_info_plus` for hardware info and `package_info_plus` for app info.
/// Generates and persists a unique device UUID using SharedPreferences.
class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceInfoService({DeviceInfoPlugin? deviceInfoPlugin})
      : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  /// Gets complete device information for API registration.
  ///
  /// This method:
  /// 1. Retrieves or generates a persistent device UUID
  /// 2. Gathers platform-specific hardware information
  /// 3. Gets the current app version
  /// 4. Gets FCM push token (if available)
  Future<DeviceInfo> getDeviceInfo() async {
    final deviceId = await getOrCreateDeviceId();
    final platform = _getPlatform();
    final deviceModel = await _getDeviceModel();
    final osVersion = await _getOsVersion();
    final appVersion = await _getAppVersion();
    final pushToken = await _getPushToken();

    return DeviceInfo(
      deviceId: deviceId,
      platform: platform,
      deviceModel: deviceModel,
      osVersion: osVersion,
      appVersion: appVersion,
      pushToken: pushToken,
    );
  }

  /// Gets the FCM push notification token.
  Future<String?> _getPushToken() async {
    try {
      return await NotificationService.instance.getToken();
    } catch (e) {
      log('[DeviceInfoService] Error getting push token: $e');
      return null;
    }
  }

  /// Gets the persistent device ID, generating one if it doesn't exist.
  Future<String> getOrCreateDeviceId() async {
    String? deviceId = MySharedPreferences.getDeviceId();

    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      await MySharedPreferences.setDeviceId(deviceId);
      log('[DeviceInfoService] Generated new device ID: $deviceId');
    } else {
      log('[DeviceInfoService] Using existing device ID: $deviceId');
    }

    return deviceId;
  }

  /// Gets the current device ID without generating a new one.
  ///
  /// Returns null if no device ID has been generated yet.
  /// Prefer using [getOrCreateDeviceId] to ensure a device ID always exists.
  String? getCurrentDeviceId() {
    return MySharedPreferences.getDeviceId();
  }

  /// Gets the platform type.
  String _getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Gets the device model name.
  Future<String> _getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        final brand = androidInfo.brand;
        final model = androidInfo.model;
        return '$brand $model';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.utsname.machine;
      }
    } catch (e) {
      log('[DeviceInfoService] Error getting device model: $e');
    }
    return 'Unknown Device';
  }

  /// Gets the OS version string.
  Future<String> _getOsVersion() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return 'iOS ${iosInfo.systemVersion}';
      }
    } catch (e) {
      log('[DeviceInfoService] Error getting OS version: $e');
    }
    return Platform.operatingSystemVersion;
  }

  /// Gets the app version string.
  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (e) {
      log('[DeviceInfoService] Error getting app version: $e');
      return '1.0.0';
    }
  }

  /// Gets detailed device information for debugging.
  Future<Map<String, String>> getDebugInfo() async {
    final info = await getDeviceInfo();
    return {
      'device_id': info.deviceId,
      'platform': info.platform,
      'device_model': info.deviceModel,
      'os_version': info.osVersion,
      'app_version': info.appVersion,
    };
  }
}
