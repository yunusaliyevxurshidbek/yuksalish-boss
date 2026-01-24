import 'package:equatable/equatable.dart';

/// Device information model for authorized devices.
class DeviceInfo extends Equatable {
  final String id;
  final String name;
  final String platform;
  final String osVersion;
  final DateTime lastActive;
  final bool isCurrentDevice;

  const DeviceInfo({
    required this.id,
    required this.name,
    required this.platform,
    required this.osVersion,
    required this.lastActive,
    required this.isCurrentDevice,
  });

  /// Creates a copy with updated fields.
  DeviceInfo copyWith({
    String? id,
    String? name,
    String? platform,
    String? osVersion,
    DateTime? lastActive,
    bool? isCurrentDevice,
  }) {
    return DeviceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      osVersion: osVersion ?? this.osVersion,
      lastActive: lastActive ?? this.lastActive,
      isCurrentDevice: isCurrentDevice ?? this.isCurrentDevice,
    );
  }

  /// Creates from JSON map.
  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      platform: json['platform'] as String,
      osVersion: json['os_version'] as String,
      lastActive: DateTime.parse(json['last_active'] as String),
      isCurrentDevice: json['is_current_device'] as bool? ?? false,
    );
  }

  /// Converts to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'os_version': osVersion,
      'last_active': lastActive.toIso8601String(),
      'is_current_device': isCurrentDevice,
    };
  }

  /// Get platform icon name.
  String get platformIcon {
    switch (platform.toLowerCase()) {
      case 'ios':
        return 'phone_iphone';
      case 'android':
        return 'phone_android';
      case 'web':
        return 'computer';
      default:
        return 'devices';
    }
  }

  /// Get formatted last active text.
  String get lastActiveText {
    if (isCurrentDevice) {
      return 'Hozir';
    }

    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 1) {
      return 'Hozirgina';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} daqiqa oldin';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} soat oldin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} kun oldin';
    } else if (difference.inDays < 30) {
      return '${difference.inDays ~/ 7} hafta oldin';
    } else {
      return '${difference.inDays ~/ 30} oy oldin';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        platform,
        osVersion,
        lastActive,
        isCurrentDevice,
      ];
}
