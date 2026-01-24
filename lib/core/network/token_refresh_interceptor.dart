import 'dart:async';

import 'package:dio/dio.dart';

import '../services/my_shared_preferences.dart';
import 'models/refresh_token_request.dart';
import 'models/refresh_token_response.dart';

class TokenRefreshInterceptor extends Interceptor {
  final Dio dio;
  final String baseUrl;

  bool _isRefreshing = false;
  final List<_QueuedRequest> _requestQueue = [];

  TokenRefreshInterceptor({
    required this.dio,
    required this.baseUrl,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = MySharedPreferences.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;
    final hasRetried = options.extra['tokenRetried'] == true;

    final isTokenError = _isTokenExpiredError(statusCode, err.response?.data);

    if (isTokenError && !hasRetried && !_isRefreshEndpoint(options.path)) {
      final refreshToken = MySharedPreferences.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        handler.next(err);
        return;
      }

      if (_isRefreshing) {
        final completer = Completer<Response>();
        _requestQueue.add(_QueuedRequest(options, handler, completer));
        try {
          final response = await completer.future;
          handler.resolve(response);
        } catch (e) {
          handler.next(err);
        }
        return;
      }

      _isRefreshing = true;

      try {
        final newTokens = await _refreshToken(refreshToken);

        if (newTokens != null) {
          await MySharedPreferences.setToken(newTokens.access);
          await MySharedPreferences.setRefreshToken(newTokens.refresh);

          options.headers['Authorization'] = 'Bearer ${newTokens.access}';
          options.extra['tokenRetried'] = true;

          final response = await dio.fetch(options);
          handler.resolve(response);

          _processQueue(newTokens.access);
        } else {
          _failQueue(err);
          handler.next(err);
        }
      } catch (e) {
        _failQueue(err);
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
      return;
    }

    handler.next(err);
  }

  bool _isRefreshEndpoint(String path) {
    return path.contains('token/refresh');
  }

  bool _isTokenExpiredError(int? statusCode, dynamic responseData) {
    // Handle 401 Unauthorized
    if (statusCode == 401) {
      return true;
    }

    // Handle 403 with token_not_valid code
    if (statusCode == 403 && responseData is Map<String, dynamic>) {
      final code = responseData['code'];
      if (code == 'token_not_valid') {
        return true;
      }
    }

    return false;
  }

  Future<RefreshTokenResponse?> _refreshToken(String refreshToken) async {
    try {
      final request = RefreshTokenRequest(refresh: refreshToken);

      final refreshDio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: dio.options.connectTimeout,
        receiveTimeout: dio.options.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ));

      final response = await refreshDio.post(
        'mobile/token/refresh/',
        data: request.toJson(),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return RefreshTokenResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _processQueue(String newAccessToken) {
    for (final queued in _requestQueue) {
      queued.options.headers['Authorization'] = 'Bearer $newAccessToken';
      queued.options.extra['tokenRetried'] = true;
      dio.fetch(queued.options).then((response) {
        queued.completer.complete(response);
      }).catchError((e) {
        queued.completer.completeError(e);
      });
    }
    _requestQueue.clear();
  }

  void _failQueue(DioException err) {
    for (final queued in _requestQueue) {
      queued.completer.completeError(err);
    }
    _requestQueue.clear();
  }
}

class _QueuedRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  final Completer<Response> completer;

  _QueuedRequest(this.options, this.handler, this.completer);
}
