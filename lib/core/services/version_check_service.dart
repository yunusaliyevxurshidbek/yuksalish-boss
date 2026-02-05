import 'dart:io';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_config_model.dart';
import 'log_service.dart';

class VersionCheckService {
  final Dio _dio;

  VersionCheckService(this._dio);

  Future<AppConfigModel?> fetchAppConfig() async {
    try {
      final response = await _dio.get('boss-app-config/');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return AppConfigModel.fromJson(data);
      }
      return null;
    } catch (e) {
      LogService.e('Failed to fetch app config: $e');
      return null;
    }
  }

  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Compares two semantic version strings.
  /// Returns -1 if v1 < v2, 0 if equal, 1 if v1 > v2.
  int compareVersions(String v1, String v2) {
    final parts1 = _parseVersion(v1);
    final parts2 = _parseVersion(v2);

    for (int i = 0; i < 3; i++) {
      if (parts1[i] < parts2[i]) return -1;
      if (parts1[i] > parts2[i]) return 1;
    }
    return 0;
  }

  List<int> _parseVersion(String version) {
    // Strip suffixes like -beta, +build
    final cleaned = version.split(RegExp(r'[-+]')).first;
    final parts = cleaned.split('.');
    return List.generate(3, (i) {
      if (i < parts.length) {
        return int.tryParse(parts[i]) ?? 0;
      }
      return 0;
    });
  }

  bool isUpdateRequired(String currentVersion, String minVersion) {
    return compareVersions(currentVersion, minVersion) < 0;
  }

  /// Returns [AppConfigModel] if update is required, null otherwise.
  Future<AppConfigModel?> checkForRequiredUpdate() async {
    try {
      final config = await fetchAppConfig();
      if (config == null) return null;

      final currentVersion = await getCurrentVersion();
      if (isUpdateRequired(currentVersion, config.minVersion)) {
        return config;
      }
      return null;
    } catch (e) {
      LogService.e('Version check failed: $e');
      return null;
    }
  }

  Future<void> openStore(AppConfigModel config) async {
    final urlString = Platform.isIOS ? config.appStoreUrl : config.playMarketUrl;
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
