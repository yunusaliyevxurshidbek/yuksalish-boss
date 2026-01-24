import 'dart:developer';

import '../../../../injection_container.dart';
import '../../domain/usecases/register_device.dart';
import 'device_info_service.dart';

/// Helper class for device registration during auth flows.
///
/// Usage:
/// - Call [registerCurrentDevice] on app launch if user is logged in
/// - Call [registerCurrentDevice] after successful login
///
/// The registration runs in the background and should not block the UI.
class DeviceRegistrationHelper {
  static DeviceRegistrationHelper? _instance;

  final DeviceInfoService _deviceInfoService;
  final RegisterDevice _registerDevice;

  DeviceRegistrationHelper._({
    required DeviceInfoService deviceInfoService,
    required RegisterDevice registerDevice,
  })  : _deviceInfoService = deviceInfoService,
        _registerDevice = registerDevice;

  /// Gets the singleton instance.
  static DeviceRegistrationHelper get instance {
    _instance ??= DeviceRegistrationHelper._(
      deviceInfoService: getIt<DeviceInfoService>(),
      registerDevice: getIt<RegisterDevice>(),
    );
    return _instance!;
  }

  /// Registers the current device with the backend.
  ///
  /// This should be called:
  /// - On app launch (if user is already logged in)
  /// - After successful login
  ///
  /// The call runs in the background and logs errors without blocking.
  Future<void> registerCurrentDevice() async {
    try {
      log('[DeviceRegistrationHelper] Starting device registration...');

      final deviceInfo = await _deviceInfoService.getDeviceInfo();

      log('[DeviceRegistrationHelper] Device info gathered: '
          'id=${deviceInfo.deviceId}, '
          'platform=${deviceInfo.platform}, '
          'model=${deviceInfo.deviceModel}');

      final result = await _registerDevice(
        RegisterDeviceParams(deviceInfo: deviceInfo),
      );

      result.fold(
        (failure) {
          log('[DeviceRegistrationHelper] Registration failed: ${failure.message}');
        },
        (device) {
          log('[DeviceRegistrationHelper] Registration successful: '
              'deviceDbId=${device.id}, '
              'lastActive=${device.lastActive}');
        },
      );
    } catch (e, stackTrace) {
      log(
        '[DeviceRegistrationHelper] Unexpected error during registration',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Gets the current device ID (persistent UUID).
  ///
  /// Returns null if device info hasn't been initialized yet.
  String? get currentDeviceId => _deviceInfoService.getCurrentDeviceId();

  /// Initializes device info and returns the device ID.
  ///
  /// This ensures a device ID is generated and stored.
  Future<String> initializeAndGetDeviceId() async {
    final info = await _deviceInfoService.getDeviceInfo();
    return info.deviceId;
  }
}
