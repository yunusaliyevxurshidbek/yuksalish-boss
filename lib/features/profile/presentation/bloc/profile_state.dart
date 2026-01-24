import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/profile_repository.dart';

/// Profile loading status.
enum ProfileStatus { initial, loading, loaded, error }

/// State for the profile cubit.
class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final List<DeviceInfo> devices;
  final ProfileStatistics statistics;
  final int cacheSize;
  final String? errorMessage;
  final bool isUpdating;
  final bool isLoggingOut;

  const ProfileState({
    required this.status,
    this.profile,
    required this.devices,
    required this.statistics,
    required this.cacheSize,
    this.errorMessage,
    required this.isUpdating,
    required this.isLoggingOut,
  });

  /// Initial state.
  factory ProfileState.initial() {
    return ProfileState(
      status: ProfileStatus.initial,
      profile: null,
      devices: const [],
      statistics: ProfileStatistics.empty(),
      cacheSize: 0,
      errorMessage: null,
      isUpdating: false,
      isLoggingOut: false,
    );
  }

  /// Create a copy with updated fields.
  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    List<DeviceInfo>? devices,
    ProfileStatistics? statistics,
    int? cacheSize,
    String? errorMessage,
    bool? isUpdating,
    bool? isLoggingOut,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      devices: devices ?? this.devices,
      statistics: statistics ?? this.statistics,
      cacheSize: cacheSize ?? this.cacheSize,
      errorMessage: errorMessage,
      isUpdating: isUpdating ?? this.isUpdating,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  /// Check if profile is loading.
  bool get isLoading => status == ProfileStatus.loading;

  /// Check if profile is loaded.
  bool get isLoaded => status == ProfileStatus.loaded;

  /// Check if there's an error.
  bool get hasError => status == ProfileStatus.error;

  /// Get user settings or default.
  UserSettings get settings =>
      profile?.settings ?? UserSettings.defaultSettings();

  /// Get formatted cache size.
  String get formattedCacheSize {
    if (cacheSize < 1024) {
      return '$cacheSize B';
    } else if (cacheSize < 1024 * 1024) {
      return '${(cacheSize / 1024).toStringAsFixed(1)} KB';
    } else if (cacheSize < 1024 * 1024 * 1024) {
      return '${(cacheSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(cacheSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        devices,
        statistics,
        cacheSize,
        errorMessage,
        isUpdating,
        isLoggingOut,
      ];
}
