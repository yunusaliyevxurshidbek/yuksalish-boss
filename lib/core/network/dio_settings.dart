import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'company_id_interceptor.dart';
import 'csrf_interceptor.dart';
import 'csrf_token_provider.dart';
import 'token_refresh_interceptor.dart';

class AppConstants {
  static const baseUrl = 'https://api.yuksalish.group/api';

  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  static const debugLogBodies = true;
  static const debugMaxBodyChars = 4000;
}

class DioSettings {
  DioSettings({
    String initialLanguage = 'uz',
    required CsrfTokenProvider csrfTokenProvider,
  })  : _language = initialLanguage,
        _csrfTokenProvider = csrfTokenProvider;

  String _language;
  final CsrfTokenProvider _csrfTokenProvider;
  Dio? _dio;

  Dio get client => _dio ??= _buildDio();

  void setLanguage(String lang) {
    _language = lang;
    _dio?.options.headers['Accept-Language'] = _language;
  }

  Dio _buildDio() {
    final baseUrl = _normalizeBaseUrl(AppConstants.baseUrl);

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        responseType: ResponseType.json,
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'Accept-Language': _language,
        },
      ),
    );

    dio.interceptors.add(
      TokenRefreshInterceptor(
        dio: dio,
        baseUrl: baseUrl,
      ),
    );

    dio.interceptors.add(CompanyIdInterceptor());

    dio.interceptors.add(
      CsrfInterceptor(
        dio: dio,
        tokenProvider: _csrfTokenProvider,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(_DebugDioLogger());
    }

    return dio;
  }

  String _normalizeBaseUrl(String url) {
    if (!url.endsWith('/')) return '$url/';
    return url;
  }
}

class _DebugDioLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri.toString();
    log('[DIO][REQ] ${options.method} $uri');

    // Log Authorization header (masked)
    final auth = options.headers['Authorization'];
    if (auth != null) {
      final token = auth.toString();
      if (token.length > 20) {
        log('[DIO][REQ][AUTH] ${token.substring(0, 20)}...');
      } else {
        log('[DIO][REQ][AUTH] $token');
      }
    } else {
      log('[DIO][REQ][AUTH] NO TOKEN');
    }

    if (options.queryParameters.isNotEmpty) {
      log('[DIO][REQ][QP] ${options.queryParameters}');
    }

    if (AppConstants.debugLogBodies && options.data != null) {
      log('[DIO][REQ][BODY] ${_shorten(options.data.toString())}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final uri = response.requestOptions.uri.toString();
    log('[DIO][RES] ${response.statusCode} ${response.requestOptions.method} $uri');

    if (AppConstants.debugLogBodies && response.data != null) {
      log('[DIO][RES][BODY] ${_shorten(response.data.toString())}');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final uri = err.requestOptions.uri.toString();
    final code = err.response?.statusCode;
    log('[DIO][ERR] $code ${err.requestOptions.method} $uri -> ${err.message}');

    if (AppConstants.debugLogBodies && err.response?.data != null) {
      log('[DIO][ERR][BODY] ${_shorten(err.response!.data.toString())}');
    }

    super.onError(err, handler);
  }

  String _shorten(String s) {
    const max = AppConstants.debugMaxBodyChars;
    if (s.length <= max) return s;
    return '${s.substring(0, max)}... (trimmed ${s.length - max} chars)';
  }
}
