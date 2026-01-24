import '../services/my_shared_preferences.dart';
import 'app_locales.dart';

class LanguagePrefs {
  static const String _key = 'language_code';

  String? getSavedLocaleCode() {
    return MySharedPreferences.getString(_key);
  }

  Future<void> saveLocaleCode(String code) async {
    await MySharedPreferences.setString(_key, normalizeLocaleCode(code));
  }
}
