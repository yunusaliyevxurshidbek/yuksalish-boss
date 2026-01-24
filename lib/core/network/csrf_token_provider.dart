import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import '../services/my_shared_preferences.dart';

class CsrfTokenProvider {
  static const String _prefsKey = 'csrf_token';
  static const String _cookiePrefsKey = 'csrf_cookie';

  final Dio _dio;
  String? _cachedToken;
  String? _cookieHeader;
  Future<String>? _inFlight;

  CsrfTokenProvider(this._dio);

  String? get cookieHeader => _cookieHeader;

  Future<String> getToken({bool forceRefresh = false}) async {
    if (_inFlight != null) {
      return _inFlight!;
    }

    if (!forceRefresh) {
      final inMemory = _cachedToken;
      if (inMemory != null && inMemory.isNotEmpty && _ensureCookieLoaded()) {
        return inMemory;
      }
      final stored = MySharedPreferences.getString(_prefsKey);
      if (stored != null && stored.isNotEmpty && _ensureCookieLoaded()) {
        _cachedToken = stored;
        return stored;
      }
    }

    _inFlight = _fetchToken();
    return _inFlight!;
  }

  Future<String> _fetchToken() async {
    try {
      final response = await _dio.get(
        'users/csrf/',
        options: Options(extra: {'skipCsrf': true}),
      );
      final token = _parseToken(response.data);
      if (token.isEmpty) {
        throw ServerExceptions(
          message: 'Failed to load CSRF token.',
          statusCode: response.statusCode,
        );
      }
      _updateCookieFromResponse(response.headers);
      _cachedToken = token;
      await MySharedPreferences.setString(_prefsKey, token);
      return token;
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException(
          'Please check your internet connection.',
        );
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is NetworkException || e is ServerExceptions) {
        rethrow;
      }
      throw ServerExceptions(message: 'Failed to load CSRF token.');
    } finally {
      _inFlight = null;
    }
  }

  bool _ensureCookieLoaded() {
    if (_cookieHeader != null && _cookieHeader!.isNotEmpty) {
      return true;
    }
    final storedCookie = MySharedPreferences.getString(_cookiePrefsKey);
    if (storedCookie != null && storedCookie.isNotEmpty) {
      _cookieHeader = storedCookie;
      return true;
    }
    return false;
  }

  void _updateCookieFromResponse(Headers headers) {
    final rawCookies = headers['set-cookie'];
    if (rawCookies == null || rawCookies.isEmpty) {
      return;
    }
    final parsed = _parseCookieHeader(rawCookies);
    if (parsed == null || parsed.isEmpty) {
      return;
    }
    _cookieHeader = parsed;
    MySharedPreferences.setString(_cookiePrefsKey, parsed);
  }

  String? _parseCookieHeader(List<String> rawCookies) {
    final cookieParts = <String>[];
    for (final raw in rawCookies) {
      final value = raw.split(';').first.trim();
      if (value.isNotEmpty) {
        cookieParts.add(value);
      }
    }
    if (cookieParts.isEmpty) {
      return null;
    }
    return cookieParts.join('; ');
  }

  String _parseToken(dynamic data) {
    if (data is Map<String, dynamic>) {
      final token = data['csrfToken'];
      if (token is String) return token;
      final altToken = data['csrf_token'];
      if (altToken is String) return altToken;
    }
    return '';
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) {
        return detail;
      }
      final errors = data['errors'];
      final errorMessage = _firstErrorFrom(errors);
      if (errorMessage != null) {
        return errorMessage;
      }
    }
    if (data is List) {
      final errorMessage = _firstErrorFrom(data);
      if (errorMessage != null) {
        return errorMessage;
      }
    }
    return 'Something went wrong. Please try again.';
  }

  String? _firstErrorFrom(dynamic errors) {
    if (errors is List && errors.isNotEmpty) {
      final first = errors.first;
      if (first is String && first.isNotEmpty) {
        return first;
      }
    }
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) {
          final first = value.first;
          if (first is String && first.isNotEmpty) {
            return first;
          }
        } else if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }
    return null;
  }
}
