import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing main shell navigation state
class MainShellCubit extends Cubit<MainShellState> {
  MainShellCubit() : super(const MainShellState());

  void setTabIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void setApprovalsCount(int count) {
    emit(state.copyWith(pendingApprovalsCount: count));
  }

  void setNotificationsBadge(bool hasUnread) {
    emit(state.copyWith(hasUnreadNotifications: hasUnread));
  }

  void setUnreadNotificationsCount(int count) {
    emit(state.copyWith(
      unreadNotificationsCount: count,
      hasUnreadNotifications: count > 0,
    ));
  }
}

/// State class for main shell navigation
class MainShellState extends Equatable {
  final int currentIndex;
  final int pendingApprovalsCount;
  final int unreadNotificationsCount;
  final bool hasUnreadNotifications;

  const MainShellState({
    this.currentIndex = 0,
    this.pendingApprovalsCount = 0,
    this.unreadNotificationsCount = 0,
    this.hasUnreadNotifications = false,
  });

  MainShellState copyWith({
    int? currentIndex,
    int? pendingApprovalsCount,
    int? unreadNotificationsCount,
    bool? hasUnreadNotifications,
  }) {
    return MainShellState(
      currentIndex: currentIndex ?? this.currentIndex,
      pendingApprovalsCount: pendingApprovalsCount ?? this.pendingApprovalsCount,
      unreadNotificationsCount: unreadNotificationsCount ?? this.unreadNotificationsCount,
      hasUnreadNotifications: hasUnreadNotifications ?? this.hasUnreadNotifications,
    );
  }

  @override
  List<Object?> get props => [
        currentIndex,
        pendingApprovalsCount,
        unreadNotificationsCount,
        hasUnreadNotifications,
      ];
}
