import 'dart:convert';

class JwtUtils {
  static Map<String, dynamic> decodeToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    return payloadMap;
  }

  static bool isTokenExpired(String token) {
    try {
      final payload = decodeToken(token);
      final exp = payload['exp'];
      if (exp == null) return true;
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return exp < currentTime;
    } catch (e) {
      return true;
    }
  }
}
