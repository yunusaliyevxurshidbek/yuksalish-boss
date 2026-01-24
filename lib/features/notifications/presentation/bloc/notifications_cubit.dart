import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/notification_item.dart';
import '../../data/repositories/notifications_repository.dart';

part 'notifications_state.dart';

/// Cubit for managing notifications state
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit({required NotificationsRepository repository})
      : _repository = repository,
        super(const NotificationsState());

  /// Load all notifications
  Future<void> loadNotifications() async {
    if (isClosed) return;
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      final notifications = await _repository.getNotifications();
      if (isClosed) return;
      final unreadCount = notifications.where((n) => !n.isRead).length;
      final grouped = _groupByDate(notifications);
      emit(state.copyWith(
        status: NotificationsStatus.loaded,
        notifications: notifications,
        groupedNotifications: grouped,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: NotificationsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Refresh notifications
  Future<void> refresh() async {
    try {
      final notifications = await _repository.getNotifications();
      if (isClosed) return;
      final unreadCount = notifications.where((n) => !n.isRead).length;
      final grouped = _groupByDate(notifications);
      emit(state.copyWith(
        notifications: notifications,
        groupedNotifications: grouped,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(int id) async {
    try {
      final updated = await _repository.markAsRead(id);
      if (isClosed) return;
      final notifications = state.notifications.map((n) {
        return n.id == id ? updated : n;
      }).toList();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      final grouped = _groupByDate(notifications);
      emit(state.copyWith(
        notifications: notifications,
        groupedNotifications: grouped,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      if (isClosed) return;
      final notifications =
          state.notifications.map((n) => n.copyWith(isRead: true)).toList();
      final grouped = _groupByDate(notifications);
      emit(state.copyWith(
        notifications: notifications,
        groupedNotifications: grouped,
        unreadCount: 0,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Delete notification
  Future<void> delete(int id) async {
    try {
      await _repository.delete(id);
      if (isClosed) return;
      final notifications =
          state.notifications.where((n) => n.id != id).toList();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      final grouped = _groupByDate(notifications);
      emit(state.copyWith(
        notifications: notifications,
        groupedNotifications: grouped,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    try {
      await _repository.clearAll();
      if (isClosed) return;
      emit(state.copyWith(
        notifications: [],
        groupedNotifications: {},
        unreadCount: 0,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Map<String, List<NotificationItem>> _groupByDate(
    List<NotificationItem> notifications,
  ) {
    final grouped = <String, List<NotificationItem>>{};
    for (final notification in notifications) {
      final key = notification.dateGroupLabel;
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(notification);
    }
    return grouped;
  }
}
