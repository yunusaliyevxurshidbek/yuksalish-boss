import '../datasources/notifications_remote_datasource.dart';
import '../models/notification_item.dart';

/// Repository for managing notifications
abstract class NotificationsRepository {
  /// Get all notifications
  Future<List<NotificationItem>> getNotifications();

  /// Get unread notifications count
  Future<int> getUnreadCount();

  /// Mark notification as read
  Future<NotificationItem> markAsRead(int id);

  /// Mark all notifications as read
  Future<void> markAllAsRead();

  /// Delete notification
  Future<void> delete(int id);

  /// Clear all notifications
  Future<void> clearAll();
}

/// Implementation with API integration
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepositoryImpl({
    required NotificationsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<NotificationItem>> getNotifications() async {
    final notifications = await _remoteDataSource.getNotifications();
    // Sort by createdAt descending (most recent first)
    notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notifications;
  }

  @override
  Future<int> getUnreadCount() async {
    return _remoteDataSource.getUnreadCount();
  }

  @override
  Future<NotificationItem> markAsRead(int id) async {
    await _remoteDataSource.markAsRead(id);
    // Fetch the updated notification from the server
    final notifications = await _remoteDataSource.getNotifications();
    return notifications.firstWhere(
      (n) => n.id == id,
      orElse: () => throw Exception('Notification not found'),
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await _remoteDataSource.markAllAsRead();
  }

  @override
  Future<void> delete(int id) async {
    // The API uses "mark as read" and "clear" but not individual delete
    // We'll use markAsRead for individual notification deletion
    await _remoteDataSource.markAsRead(id);
  }

  @override
  Future<void> clearAll() async {
    await _remoteDataSource.clearAll();
  }
}
