import '../../domain/entities/user_device.dart';

/// Data model for user device from API response.
class UserDeviceModel {
  final int id;
  final String deviceId;
  final String platform;
  final String deviceModel;
  final String osVersion;
  final String appVersion;
  final DateTime lastActive;
  final DateTime createdAt;
  final bool isCurrent;

  const UserDeviceModel({
    required this.id,
    required this.deviceId,
    required this.platform,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
    required this.lastActive,
    required this.createdAt,
    required this.isCurrent,
  });

  factory UserDeviceModel.fromJson(Map<String, dynamic> json) {
    return UserDeviceModel(
      id: json['id'] as int? ?? 0,
      deviceId: json['device_id'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      deviceModel: json['device_model'] as String? ?? '',
      osVersion: json['os_version'] as String? ?? '',
      appVersion: json['app_version'] as String? ?? '',
      lastActive: _parseDateTime(json['last_active']),
      createdAt: _parseDateTime(json['created_at']),
      isCurrent: json['is_current'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'platform': platform,
      'device_model': deviceModel,
      'os_version': osVersion,
      'app_version': appVersion,
      'last_active': lastActive.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'is_current': isCurrent,
    };
  }

  UserDevice toEntity() {
    return UserDevice(
      id: id,
      deviceId: deviceId,
      platform: platform,
      deviceModel: deviceModel,
      osVersion: osVersion,
      appVersion: appVersion,
      lastActive: lastActive,
      createdAt: createdAt,
      isCurrent: isCurrent,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
