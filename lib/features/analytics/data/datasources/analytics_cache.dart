import 'dart:convert';

import '../../../../core/services/my_shared_preferences.dart';
import '../models/analytics_period.dart';

/// Simple shared-preferences cache for analytics endpoints.
class AnalyticsCache {
  static const String _statsPrefix = 'analytics_cache_stats_';
  static const String _clientsKey = 'analytics_cache_clients';
  static const String _contractsKey = 'analytics_cache_contracts';
  static const String _paymentsKey = 'analytics_cache_payments';
  static const String _projectsKey = 'analytics_cache_projects';
  static const String _apartmentsKey = 'analytics_cache_apartments';
  static const String _lastUpdatedKey = 'analytics_cache_last_updated';

  Future<void> saveStats(AnalyticsPeriod period, Map<String, dynamic> data) async {
    await MySharedPreferences.setString(
      '$_statsPrefix${period.name}',
      jsonEncode(data),
    );
    await _updateLastUpdated();
  }

  Map<String, dynamic>? getStats(AnalyticsPeriod period) {
    final raw = MySharedPreferences.getString('$_statsPrefix${period.name}');
    return _decodeMap(raw);
  }

  Future<void> saveClients(List<dynamic> data) async {
    await MySharedPreferences.setString(_clientsKey, jsonEncode(data));
    await _updateLastUpdated();
  }

  List<Map<String, dynamic>>? getClients() => _decodeList(MySharedPreferences.getString(_clientsKey));

  Future<void> saveContracts(List<dynamic> data) async {
    await MySharedPreferences.setString(_contractsKey, jsonEncode(data));
    await _updateLastUpdated();
  }

  List<Map<String, dynamic>>? getContracts() => _decodeList(MySharedPreferences.getString(_contractsKey));

  Future<void> savePayments(List<dynamic> data) async {
    await MySharedPreferences.setString(_paymentsKey, jsonEncode(data));
    await _updateLastUpdated();
  }

  List<Map<String, dynamic>>? getPayments() => _decodeList(MySharedPreferences.getString(_paymentsKey));

  Future<void> saveProjects(List<dynamic> data) async {
    await MySharedPreferences.setString(_projectsKey, jsonEncode(data));
    await _updateLastUpdated();
  }

  List<Map<String, dynamic>>? getProjects() => _decodeList(MySharedPreferences.getString(_projectsKey));

  Future<void> saveApartments(List<dynamic> data) async {
    await MySharedPreferences.setString(_apartmentsKey, jsonEncode(data));
    await _updateLastUpdated();
  }

  List<Map<String, dynamic>>? getApartments() => _decodeList(MySharedPreferences.getString(_apartmentsKey));

  DateTime? getLastUpdated() {
    final millis = MySharedPreferences.getInt(_lastUpdatedKey);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<void> _updateLastUpdated() async {
    await MySharedPreferences.setInt(
      _lastUpdatedKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic>? _decodeMap(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }

  List<Map<String, dynamic>>? _decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<Map<String, dynamic>>().toList();
      }
    } catch (_) {}
    return null;
  }
}
