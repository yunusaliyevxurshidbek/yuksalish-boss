import '../../domain/entities/device_info.dart';

/// Request model for registering/updating a device.
class RegisterDeviceRequestModel {
  final String deviceId;
  final String platform;
  final String deviceModel;
  final String osVersion;
  final String appVersion;

  const RegisterDeviceRequestModel({
    required this.deviceId,
    required this.platform,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
  });

  factory RegisterDeviceRequestModel.fromDeviceInfo(DeviceInfo deviceInfo) {
    return RegisterDeviceRequestModel(
      deviceId: deviceInfo.deviceId,
      platform: deviceInfo.platform,
      deviceModel: deviceInfo.deviceModel,
      osVersion: deviceInfo.osVersion,
      appVersion: deviceInfo.appVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'platform': platform,
      'device_model': deviceModel,
      'os_version': osVersion,
      'app_version': appVersion,
    };
  }
}
