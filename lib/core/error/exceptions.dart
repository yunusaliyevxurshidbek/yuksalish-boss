class ServerExceptions implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ServerExceptions({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  bool get isPhoneExists => errorCode == 'PHONE_EXISTS';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

