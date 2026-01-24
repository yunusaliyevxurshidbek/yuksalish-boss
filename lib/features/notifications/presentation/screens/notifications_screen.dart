import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/notification_item.dart';
import '../bloc/notifications_cubit.dart';
import '../theme/notifications_theme.dart';
import '../widgets/notification_app_bar.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_context_menu.dart';
import '../widgets/notification_delete_dialog.dart';
import '../widgets/notification_empty_state.dart';
import '../widgets/notification_filter_tabs.dart';
import '../widgets/notification_loading_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _badgeController;
  late final Animation<double> _badgeScale;
  final ScrollController _scrollController = ScrollController();

  late NotificationFilter _selectedFilter = NotificationFilter.all;

  @override
  void initState() {
    super.initState();
    _initBadgeAnimation();
    _scrollController.addListener(_onScroll);
  }

  void _initBadgeAnimation() {
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _badgeScale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final threshold = 200.h;
      if (_scrollController.position.extentAfter < threshold) {
        // Could implement infinite scroll here if needed
      }
    }
  }

  void _updateBadgeAnimation(int unreadCount) {
    if (unreadCount > 0) {
      if (!_badgeController.isAnimating) {
        _badgeController.repeat(reverse: true);
      }
    } else {
      _badgeController.stop();
      _badgeController.value = 0.5;
    }
  }

  void _triggerFeedback() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.mediumImpact();
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Mark as read
    context.read<NotificationsCubit>().markAsRead(notification.id);

    // Navigate based on type
    switch (notification.type) {
      case NotificationType.newLead:
      case NotificationType.leadAssigned:
        if (notification.leadId != null) {
          context.go('/projects');
        }
        break;
      case NotificationType.newTask:
      case NotificationType.taskAssigned:
      case NotificationType.taskDue:
        if (notification.taskId != null) {
          context.go('/projects');
        }
        break;
      case NotificationType.newContract:
        if (notification.contractId != null) {
          context.go('/projects');
        }
        break;
      case NotificationType.paymentReceived:
      case NotificationType.paymentOverdue:
        context.go('/finance');
        break;
      case NotificationType.newClient:
        if (notification.clientId != null) {
          context.go('/projects');
        }
        break;
      case NotificationType.newProject:
        if (notification.projectId != null) {
          context.go('/projects');
        }
        break;
      case NotificationType.newProperty:
      case NotificationType.newListing:
      case NotificationType.aiRecommendation:
      case NotificationType.priceDrop:
      case NotificationType.savedSearch:
        if (notification.propertyId != null) {
          context.go('/projects');
        }
        break;
      case NotificationType.newBlog:
        context.go('/projects');
        break;
      // Legacy support
      case NotificationType.approvalPending:
        context.go('/approvals');
        break;
      case NotificationType.overduePayment:
        context.go('/finance');
        break;
      case NotificationType.contractSigned:
        context.go('/projects');
        break;
    }
  }

  void _showContextMenu(NotificationItem notification) {
    NotificationContextMenu.show(
      context,
      notification: notification,
      onToggleRead: () {
        if (notification.isRead) {
          // For now, we only support marking as read, not unread
          // You could extend the API to support this
        } else {
          context.read<NotificationsCubit>().markAsRead(notification.id);
        }
      },
      onViewDetails: () => _handleNotificationTap(notification),
      onDelete: () async {
        final confirmed = await NotificationDeleteDialog.show(context);
        if (confirmed) {
          context.read<NotificationsCubit>().delete(notification.id);
          _triggerFeedback();
        }
      },
    );
  }

  void _handleMenuAction(NotificationMenuAction action) {
    switch (action) {
      case NotificationMenuAction.markAllRead:
        context.read<NotificationsCubit>().markAllAsRead();
        _triggerFeedback();
      case NotificationMenuAction.clearAll:
        context.read<NotificationsCubit>().clearAll();
        _triggerFeedback();
    }
  }

  List<NotificationItem> _getFilteredNotifications(List<NotificationItem> notifications) {
    return switch (_selectedFilter) {
      NotificationFilter.all => notifications,
      NotificationFilter.unread => notifications.where((n) => !n.isRead).toList(),
      NotificationFilter.important => notifications, // Could add importance flag if needed
    };
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

  String _localizeGroupLabel(String label) {
    if (label == 'notifications_group_today' ||
        label == 'notifications_group_yesterday') {
      return label.tr();
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        // Load notifications on first build
        if (state.status == NotificationsStatus.initial) {
          Future.microtask(
            () => context.read<NotificationsCubit>().loadNotifications(),
          );
        }

        _updateBadgeAnimation(state.unreadCount);

        return Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: NotificationAppBar(
            unreadCount: state.unreadCount,
            badgeScale: _badgeScale,
            onMenuAction: (action) => _handleMenuAction(action),
          ),
          body: Column(
            children: [
              SizedBox(height: 8.h),
              NotificationFilterTabs(
                selectedFilter: _selectedFilter,
                onChanged: (filter) => setState(() => _selectedFilter = filter),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: _buildBody(state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(NotificationsState state) {
    final colors = NotificationThemeColors.of(context);

    if (state.status == NotificationsStatus.loading) {
      return const NotificationLoadingState();
    }

    if (state.status == NotificationsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: colors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              state.errorMessage ?? 'common_error'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationsCubit>().loadNotifications();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
              ),
              child: Text('notifications_reload'.tr()),
            ),
          ],
        ),
      );
    }

    final filteredNotifications = _getFilteredNotifications(state.notifications);

    if (filteredNotifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await context.read<NotificationsCubit>().refresh();
        },
        color: colors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 120.h),
            const NotificationEmptyState(),
          ],
        ),
      );
    }

    return _buildNotificationList(filteredNotifications);
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    final colors = NotificationThemeColors.of(context);
    final grouped = _groupByDate(notifications);
    final groupKeys = grouped.keys.toList();

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<NotificationsCubit>().refresh();
      },
      color: colors.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: groupKeys.length,
        itemBuilder: (context, groupIndex) {
          final groupLabel = groupKeys[groupIndex];
          final groupNotifications = grouped[groupLabel]!;
          final displayLabel = _localizeGroupLabel(groupLabel);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
                child: Text(
                  displayLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...List.generate(
                groupNotifications.length,
                (index) => _buildNotificationItem(groupNotifications[index]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: NotificationCard(
        notification: notification,
        onTap: () => _handleNotificationTap(notification),
        onLongPress: () => _showContextMenu(notification),
        onDismiss: () {
          context.read<NotificationsCubit>().delete(notification.id);
          _triggerFeedback();
        },
      ),
    );
  }
}

