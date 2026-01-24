import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/notification_item.dart';

/// Abstract class for notifications remote data source
abstract class NotificationsRemoteDataSource {
  /// Get all CRM notifications
  Future<List<NotificationItem>> getNotifications();

  /// Get unread notifications count for CRM
  Future<int> getUnreadCount();

  /// Mark single notification as read
  Future<void> markAsRead(int id);

  /// Mark all notifications as read
  Future<void> markAllAsRead();

  /// Clear all notifications
  Future<void> clearAll();
}

/// Implementation of NotificationsRemoteDataSource
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio _dio;

  NotificationsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<NotificationItem>> getNotifications() async {
    try {
      final response = await _dio.get(
        'users/notifications/',
        queryParameters: {'source': 'crm'},
      );

      final data = response.data;
      if (data is List) {
        return data
            .map((json) => NotificationItem.fromApiJson(json))
            .toList();
      }

      if (data is Map<String, dynamic> && data.containsKey('results')) {
        final results = data['results'];
        if (results is List) {
          return results
              .map((json) => NotificationItem.fromApiJson(json))
              .toList();
        }
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(
        'users/notifications/unread_count/',
        queryParameters: {'source': 'crm'},
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('count')) {
        return data['count'] as int;
      }

      throw ServerExceptions(
        message: 'Unexpected response format.',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      await _dio.post(
        'users/notifications/$id/mark_read/',
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dio.post(
        'users/notifications/mark_all_read/',
        queryParameters: {'source': 'crm'},
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _dio.delete(
        'users/notifications/clear_all/',
        queryParameters: {'source': 'crm'},
      );
    } on DioException catch (e) {
      if (e.response == null) {
        throw NetworkException('Internetga ulanishni tekshiring.');
      }
      final message = _extractMessage(e.response?.data);
      throw ServerExceptions(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Extract error message from response data
  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('detail')) {
        return data['detail'].toString();
      }
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data.containsKey('status')) {
        return data['status'].toString();
      }
    }
    return 'Unknown error occurred.';
  }
}
