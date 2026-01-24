import 'dart:developer';

import 'package:dio/dio.dart';

import '../services/my_shared_preferences.dart';

/// Interceptor that adds X-Company-Id header to all requests.
/// Reads the company ID from SharedPreferences.
class CompanyIdInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final companyId = MySharedPreferences.getCompanyId();
    if (companyId != null) {
      options.headers['X-Company-ID'] = companyId.toString();
      log('[DIO][COMPANY] X-Company-ID: $companyId');
    } else {
      log('[DIO][COMPANY] WARNING: No company ID stored!');
    }
    super.onRequest(options, handler);
  }
}
