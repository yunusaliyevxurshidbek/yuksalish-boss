import 'package:equatable/equatable.dart';

/// Entity representing a user's registered device/session.
class UserDevice extends Equatable {
  /// Database ID of the device record.
  final int id;

  /// Unique device identifier (UUID stored locally).
  final String deviceId;

  /// Platform type (e.g., "android", "ios").
  final String platform;

  /// Device model name (e.g., "Samsung Galaxy S21").
  final String deviceModel;

  /// Operating system version (e.g., "Android 13", "iOS 17.0").
  final String osVersion;

  /// Application version (e.g., "1.2.3").
  final String appVersion;

  /// Timestamp of last activity.
  final DateTime lastActive;

  /// Timestamp when the device was first registered.
  final DateTime createdAt;

  /// Whether this is the current device making the request.
  final bool isCurrent;

  const UserDevice({
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

  /// Returns a human-readable device name.
  String get displayName {
    if (deviceModel.isNotEmpty) {
      return deviceModel;
    }
    return '${platform.capitalize} Device';
  }

  /// Returns a formatted platform and OS string.
  String get platformInfo {
    if (osVersion.isNotEmpty) {
      return '$platform $osVersion';
    }
    return platform;
  }

  /// Returns relative time description for last active.
  String get lastActiveRelative {
    final now = DateTime.now();
    final diff = now.difference(lastActive);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${lastActive.day}/${lastActive.month}/${lastActive.year}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        deviceId,
        platform,
        deviceModel,
        osVersion,
        appVersion,
        lastActive,
        createdAt,
        isCurrent,
      ];
}

extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
