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

  const DeviceInfo({
    required this.deviceId,
    required this.platform,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
  });

  @override
  List<Object?> get props => [
        deviceId,
        platform,
        deviceModel,
        osVersion,
        appVersion,
      ];
}
