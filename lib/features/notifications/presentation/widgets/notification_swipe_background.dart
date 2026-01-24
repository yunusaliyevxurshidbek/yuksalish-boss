import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

/// Swipe background for dismissible notification cards.
class NotificationSwipeBackground extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final String labelKey;
  final Color color;

  const NotificationSwipeBackground({
    super.key,
    required this.alignment,
    required this.icon,
    required this.labelKey,
    required this.color,
  });

  /// Creates a delete swipe background (left swipe).
  factory NotificationSwipeBackground.delete() {
    return const NotificationSwipeBackground(
      alignment: Alignment.centerLeft,
      icon: Icons.delete_outline,
      labelKey: 'notifications_action_delete',
      color: Color(0xFFEF4444), // AppColors.errorColor
    );
  }

  /// Creates a mark as read/unread swipe background (right swipe).
  factory NotificationSwipeBackground.toggleRead({required bool isRead}) {
    return NotificationSwipeBackground(
      alignment: Alignment.centerRight,
      icon: isRead ? Icons.markunread : Icons.mark_email_read,
      labelKey: isRead
          ? 'notifications_status_unread'
          : 'notifications_status_read',
      color: const Color(0xFF2563EB), // AppColors.primaryColor
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.w),
      ),
      alignment: alignment,
      child: Row(
        mainAxisAlignment: alignment == Alignment.centerLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Icon(icon, color: color, size: 20.w),
          SizedBox(width: 8.w),
          Text(
            labelKey.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
