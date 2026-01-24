import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the current navigation index
final currentNavIndexProvider = StateProvider<int>((ref) => 0);

/// Provider for pending approvals count (shown as badge)
///
/// In production, this would fetch from an API or local database.
/// For now, using mock data.
final pendingApprovalsCountProvider = Provider<int>((ref) {
  // Mock data: 5 pending approvals
  return 5;
});

/// Provider for unread notifications count (shown as badge on bottom nav)
final unreadNotificationsCountProvider = Provider<int>((ref) {
  // Mock data: 3 unread notifications
  return 3;
});

/// Provider to check if user has unread notifications
final hasUnreadNotificationsProvider = Provider<bool>((ref) {
  // Mock data: user has unread notifications
  return true;
});

/// Main shell state notifier for complex navigation logic
class MainShellNotifier extends StateNotifier<MainShellState> {
  MainShellNotifier() : super(const MainShellState());

  void setTabIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void setApprovalsCount(int count) {
    state = state.copyWith(pendingApprovalsCount: count);
  }

  void setNotificationsBadge(bool hasUnread) {
    state = state.copyWith(hasUnreadNotifications: hasUnread);
  }
}

/// State class for main shell
class MainShellState {
  final int currentIndex;
  final int pendingApprovalsCount;
  final bool hasUnreadNotifications;

  const MainShellState({
    this.currentIndex = 0,
    this.pendingApprovalsCount = 0,
    this.hasUnreadNotifications = false,
  });

  MainShellState copyWith({
    int? currentIndex,
    int? pendingApprovalsCount,
    bool? hasUnreadNotifications,
  }) {
    return MainShellState(
      currentIndex: currentIndex ?? this.currentIndex,
      pendingApprovalsCount: pendingApprovalsCount ?? this.pendingApprovalsCount,
      hasUnreadNotifications: hasUnreadNotifications ?? this.hasUnreadNotifications,
    );
  }
}

/// Provider for main shell state notifier
final mainShellProvider = StateNotifierProvider<MainShellNotifier, MainShellState>((ref) {
  return MainShellNotifier();
});
