import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/models/notification_item.dart';
import '../theme/notifications_theme.dart';

/// Context menu bottom sheet for notification actions.
class NotificationContextMenu extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onToggleRead;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const NotificationContextMenu({
    super.key,
    required this.notification,
    required this.onToggleRead,
    required this.onViewDetails,
    required this.onDelete,
  });

  static void show(
    BuildContext context, {
    required NotificationItem notification,
    required VoidCallback onToggleRead,
    required VoidCallback onViewDetails,
    required VoidCallback onDelete,
  }) {
    final colors = NotificationThemeColors.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => NotificationContextMenu(
        notification: notification,
        onToggleRead: () {
          context.pop();
          onToggleRead();
        },
        onViewDetails: () {
          context.pop();
          onViewDetails();
        },
        onDelete: () {
          context.pop();
          onDelete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(height: 12.h),
          _ContextActionTile(
            icon: notification.isRead ? Icons.markunread : Icons.mark_email_read,
            label: notification.isRead
                ? 'notifications_action_mark_unread'
                : 'notifications_action_mark_read',
            onTap: onToggleRead,
          ),
          _ContextActionTile(
            icon: Icons.description_outlined,
            label: 'notifications_action_view_details',
            onTap: onViewDetails,
          ),
          _ContextActionTile(
            icon: Icons.delete_outline,
            label: 'notifications_action_delete',
            isDestructive: true,
            onTap: onDelete,
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

class _ContextActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ContextActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);
    final color = isDestructive ? colors.error : colors.textPrimary;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 20.w),
      title: Text(
        label.tr(),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
