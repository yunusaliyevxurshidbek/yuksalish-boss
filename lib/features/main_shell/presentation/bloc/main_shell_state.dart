import 'package:equatable/equatable.dart';

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
