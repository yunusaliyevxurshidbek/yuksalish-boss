part of 'notifications_cubit.dart';

/// Status of notifications loading
enum NotificationsStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State for notifications
class NotificationsState extends Equatable {
  final NotificationsStatus status;
  final List<NotificationItem> notifications;
  final Map<String, List<NotificationItem>> groupedNotifications;
  final int unreadCount;
  final String? errorMessage;

  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.groupedNotifications = const {},
    this.unreadCount = 0,
    this.errorMessage,
  });

  /// Check if there are unread notifications
  bool get hasUnread => unreadCount > 0;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItem>? notifications,
    Map<String, List<NotificationItem>>? groupedNotifications,
    int? unreadCount,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      groupedNotifications: groupedNotifications ?? this.groupedNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notifications,
        groupedNotifications,
        unreadCount,
        errorMessage,
      ];
}
