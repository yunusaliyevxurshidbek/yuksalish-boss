import 'package:equatable/equatable.dart';

/// Entity containing device information for registration.
class DeviceInfo extends Equatable {
  /// Unique device identifier (UUID).
  final String deviceId;

  /// Platform type (e.g., "android", "ios").
  final String platform;

  /// Device model name.
  final String deviceModel;

  /// Operating system version.
  final String osVersion;

  /// Application version.
  final String appVersion;

  /// FCM push notification token.
  final String? pushToken;

  const DeviceInfo({
    required this.deviceId,
    required this.platform,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
    this.pushToken,
  });

  /// Creates a copy with an updated push token.
  DeviceInfo copyWithPushToken(String? pushToken) {
    return DeviceInfo(
      deviceId: deviceId,
      platform: platform,
      deviceModel: deviceModel,
      osVersion: osVersion,
      appVersion: appVersion,
      pushToken: pushToken,
    );
  }

  @override
  List<Object?> get props => [
        deviceId,
        platform,
        deviceModel,
        osVersion,
        appVersion,
        pushToken,
      ];
}
