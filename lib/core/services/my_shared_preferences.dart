import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static late SharedPreferences _preferences;

  static final MySharedPreferences _instance = MySharedPreferences._internal();

  factory MySharedPreferences() {
    return _instance;
  }

  MySharedPreferences._internal();

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  static Future<void> setDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    await _preferences.setStringList(key, value);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Clears all user data except first launch flag.
  /// Use this for logout to preserve onboarding completion status.
  static Future<void> clearUserData() async {
    await _preferences.remove(_token);
    await _preferences.remove(_refreshToken);
    await _preferences.remove(_id);
    await _preferences.remove(_email);
    await _preferences.remove(_name);
    await _preferences.remove(_phone);
    await _preferences.remove(_companyId);
    await _preferences.remove(_registrationPending);
    // Note: _firstLaunchCompleted is intentionally NOT cleared
  }

  static const String _token = "token";
  static const String _refreshToken = "refresh_token";
  static const String _id = "user_id";
  static const String _email = "email";
  static const String _name = "user_name";
  static const String _phone = "user_phone";
  static const String _companyId = 'company_id';
  static const String _deviceId = 'device_id';
  static const String _firstLaunchCompleted = "first_launch_completed";
  static const String _registrationPending = 'registration_pending';
  static const String _recentSearches = "recent_searches";
  static const int _maxRecentSearches = 10;




  // access_token
  static Future<void> setToken(String token) async {
    await setString(_token, token);
  }

  static String? getToken() {
    return getString(_token);
  }

  // refresh_token:
  static Future<void> setRefreshToken(String refreshToken) async {
    await setString(_refreshToken, refreshToken);
  }

  static String? getRefreshToken() {
    return getString(_refreshToken);
  }

  // user_id:
  static Future<void> setId(int id) async {
    await setInt(_id, id);
  }

  static int? getId() {
    return getInt(_id);
  }

  // email:
  static Future<void> setEmail(String email) async {
    await setString(_email, email);
  }

  static String? getEmail() {
    return getString(_email);
  }

  // name:
  static Future<void> setName(String name) async {
    await setString(_name, name);
  }

  static String? getName() {
    return getString(_name);
  }

  // phone:
  static Future<void> setPhone(String phone) async {
    await setString(_phone, phone);
  }

  static String? getPhone() {
    return getString(_phone);
  }

  // company_id:
  static Future<void> setCompanyId(int companyId) async {
    await setInt(_companyId, companyId);
  }

  static int? getCompanyId() {
    return getInt(_companyId);
  }

  // device_id (persistent UUID for device registration):
  static Future<void> setDeviceId(String deviceId) async {
    await setString(_deviceId, deviceId);
  }

  static String? getDeviceId() {
    return getString(_deviceId);
  }

  // first_launch:
  static Future<void> setFirstLaunchCompleted(bool completed) async {
    await setBool(_firstLaunchCompleted, completed);
  }

  static bool isFirstLaunchCompleted() {
    return getBool(_firstLaunchCompleted) ?? false;
  }

  // registration_pending:
  static Future<void> setRegistrationPending(bool pending) async {
    await setBool(_registrationPending, pending);
  }

  static bool isRegistrationPending() {
    return getBool(_registrationPending) ?? false;
  }

  // Recent Searches
  static List<String> getRecentSearches() {
    return getStringList(_recentSearches) ?? [];
  }

  static Future<void> setRecentSearches(List<String> searches) async {
    // Limit to max recent searches
    final limitedSearches = searches.length > _maxRecentSearches
        ? searches.sublist(0, _maxRecentSearches)
        : searches;
    await setStringList(_recentSearches, limitedSearches);
  }

  static Future<void> addRecentSearch(String searchTerm) async {
    if (searchTerm.trim().isEmpty) return;

    final searches = getRecentSearches();
    // Remove if already exists (to move to top)
    searches.remove(searchTerm);
    // Add to beginning
    searches.insert(0, searchTerm);
    // Keep only max items
    if (searches.length > _maxRecentSearches) {
      searches.removeLast();
    }
    await setRecentSearches(searches);
  }

  static Future<void> removeRecentSearch(int index) async {
    final searches = getRecentSearches();
    if (index >= 0 && index < searches.length) {
      searches.removeAt(index);
      await setRecentSearches(searches);
    }
  }

  static Future<void> clearRecentSearches() async {
    await _preferences.remove(_recentSearches);
  }
}