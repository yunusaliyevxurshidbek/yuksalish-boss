import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import 'csrf_token_provider.dart';

class CsrfInterceptor extends Interceptor {
  final Dio _dio;
  final CsrfTokenProvider _tokenProvider;

  CsrfInterceptor({
    required Dio dio,
    required CsrfTokenProvider tokenProvider,
  })  : _dio = dio,
        _tokenProvider = tokenProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_shouldSkip(options)) {
      handler.next(options);
      return;
    }

    try {
      final token = await _tokenProvider.getToken();
      options.headers['X-CSRFToken'] = token;
      final cookie = _tokenProvider.cookieHeader;
      if (cookie != null && cookie.isNotEmpty) {
        options.headers.putIfAbsent('Cookie', () => cookie);
      }
      handler.next(options);
    } on NetworkException catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: e,
        ),
      );
    } on ServerExceptions catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: e.statusCode,
            data: {'message': e.message},
          ),
          type: DioExceptionType.badResponse,
          error: e,
        ),
      );
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;
    final hasRetried = options.extra['csrfRetried'] == true;

    if (statusCode == 403 && !hasRetried) {
      try {
        final token = await _tokenProvider.getToken(forceRefresh: true);
        options.headers['X-CSRFToken'] = token;
        final cookie = _tokenProvider.cookieHeader;
        if (cookie != null && cookie.isNotEmpty) {
          options.headers['Cookie'] = cookie;
        }
        options.extra['csrfRetried'] = true;
        options.extra['skipCsrf'] = true;

        final response = await _dio.fetch(options);
        handler.resolve(response);
        return;
      } catch (_) {
        // Fall through to default error handling.
      }
    }

    handler.next(err);
  }

  bool _shouldSkip(RequestOptions options) {
    final method = options.method.toUpperCase();
    if (method == 'GET' || method == 'HEAD' || method == 'OPTIONS') {
      return true;
    }
    return options.extra['skipCsrf'] == true;
  }
}
