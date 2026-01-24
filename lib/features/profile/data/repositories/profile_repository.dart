import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../../core/services/my_shared_preferences.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/models.dart';

/// Abstract interface for profile data operations.
abstract class ProfileRepository {
  /// Get current user profile.
  Future<UserProfile> getProfile();

  /// Update user profile.
  Future<UserProfile> updateProfile(UserProfile profile);

  /// Update user settings.
  Future<UserSettings> updateSettings(UserSettings settings);

  /// Get authorized devices.
  Future<List<DeviceInfo>> getDevices();

  /// Remove a device.
  Future<void> removeDevice(String deviceId);

  /// Remove all devices except current.
  Future<void> removeAllDevices();

  /// Get cache size in bytes.
  Future<int> getCacheSize();

  /// Clear cache.
  Future<void> clearCache();
}

/// Statistics for profile display.
class ProfileStatistics {
  final int approvedCount;
  final int rejectedCount;
  final int pendingCount;

  const ProfileStatistics({
    required this.approvedCount,
    required this.rejectedCount,
    required this.pendingCount,
  });

  factory ProfileStatistics.empty() {
    return const ProfileStatistics(
      approvedCount: 0,
      rejectedCount: 0,
      pendingCount: 0,
    );
  }
}

/// Implementation of ProfileRepository using real API calls.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  // Mock data for features not yet implemented on API
  List<DeviceInfo> _devices = [
    DeviceInfo(
      id: '1',
      name: 'iPhone 15 Pro Max',
      platform: 'iOS',
      osVersion: '17.4',
      lastActive: DateTime.now(),
      isCurrentDevice: true,
    ),
    DeviceInfo(
      id: '2',
      name: 'Samsung Galaxy S24',
      platform: 'Android',
      osVersion: '14',
      lastActive: DateTime.now().subtract(const Duration(days: 2)),
      isCurrentDevice: false,
    ),
    DeviceInfo(
      id: '3',
      name: 'MacBook Pro',
      platform: 'Web',
      osVersion: 'Chrome 122',
      lastActive: DateTime.now().subtract(const Duration(days: 5)),
      isCurrentDevice: false,
    ),
  ];

  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<UserProfile> getProfile() async {
    return await _remoteDataSource.getProfile();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    return await _remoteDataSource.updateProfile(
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
      phone: profile.phone,
    );
  }

  @override
  Future<UserSettings> updateSettings(UserSettings settings) async {
    // TODO: Implement real API call when endpoint is available
    await Future.delayed(const Duration(milliseconds: 300));
    return settings;
  }

  @override
  Future<List<DeviceInfo>> getDevices() async {
    // TODO: Implement real API call when endpoint is available
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_devices);
  }

  @override
  Future<void> removeDevice(String deviceId) async {
    // TODO: Implement real API call when endpoint is available
    await Future.delayed(const Duration(milliseconds: 500));
    _devices = _devices.where((d) => d.id != deviceId).toList();
  }

  @override
  Future<void> removeAllDevices() async {
    // TODO: Implement real API call when endpoint is available
    await Future.delayed(const Duration(milliseconds: 500));
    _devices = _devices.where((d) => d.isCurrentDevice).toList();
  }

  @override
  Future<int> getCacheSize() async {
    // Cache size calculation is not directly available from flutter_cache_manager
    // Return 0 as we clear the cache completely
    return 0;
  }

  @override
  Future<void> clearCache() async {
    // Clear image cache
    await _cacheManager.emptyCache();

    // Clear recent searches (preserves user auth data)
    await MySharedPreferences.clearRecentSearches();
  }
}
