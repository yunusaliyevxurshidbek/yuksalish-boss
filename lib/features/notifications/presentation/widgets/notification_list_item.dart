import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/notification_item.dart';
import '../theme/notifications_theme.dart';

/// List item widget for displaying a notification
class NotificationListItem extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationListItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);
    final isRead = notification.isRead;
    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppSizes.p16.w),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: colors.textOnPrimary,
          size: AppSizes.iconL.w,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppSizes.p12.w),
          decoration: BoxDecoration(
            color: isRead
                ? colors.cardBackground
                : colors.infoLight.withValues(
                    alpha: colors.isDark ? 0.35 : 0.55,
                  ),
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            border: Border.all(
              color: isRead
                  ? colors.border
                  : colors.info.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(colors),
              SizedBox(width: AppSizes.p12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (!isRead) ...[
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: colors.info,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: AppSizes.p8.w),
                        ],
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: colors.textPrimary,
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.p4.h),
                    Text(
                      notification.body,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSizes.p4.h),
                    Text(
                      notification.formattedTime,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(NotificationThemeColors colors) {
    final (color, bgColor, icon) = _getTypeStyle(colors);
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: colors.typeBackground(bgColor),
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, color: color, size: AppSizes.iconM.w)
            : Text(
                notification.typeEmoji,
                style: TextStyle(fontSize: 18.sp),
              ),
      ),
    );
  }

  (Color, Color, IconData?) _getTypeStyle(NotificationThemeColors colors) {
    return switch (notification.type) {
      NotificationType.newLead => (
          colors.success,
          colors.successLight,
          Icons.person_add_outlined,
        ),
      NotificationType.paymentReceived => (
          colors.success,
          colors.successLight,
          Icons.payments_outlined,
        ),
      NotificationType.paymentOverdue => (
          colors.warning,
          colors.warningLight,
          Icons.warning_amber_rounded,
        ),
      NotificationType.overduePayment => (
          colors.warning,
          colors.warningLight,
          Icons.warning_amber_rounded,
        ),
      NotificationType.approvalPending => (
          colors.info,
          colors.infoLight,
          Icons.pending_actions_outlined,
        ),
      NotificationType.newContract => (
          colors.primary,
          colors.infoLight,
          Icons.description_outlined,
        ),
      NotificationType.leadAssigned => (
          colors.success,
          colors.successLight,
          Icons.person_add_outlined,
        ),
      NotificationType.newTask => (
          colors.info,
          colors.infoLight,
          Icons.assignment_outlined,
        ),
      NotificationType.taskAssigned => (
          colors.info,
          colors.infoLight,
          Icons.assignment_outlined,
        ),
      NotificationType.taskDue => (
          colors.warning,
          colors.warningLight,
          Icons.schedule_outlined,
        ),
      NotificationType.newClient => (
          colors.success,
          colors.successLight,
          Icons.people_outlined,
        ),
      NotificationType.newProject => (
          colors.primary,
          colors.infoLight,
          Icons.business_outlined,
        ),
      NotificationType.newProperty => (
          colors.primary,
          colors.infoLight,
          Icons.house_outlined,
        ),
      NotificationType.aiRecommendation => (
          colors.info,
          colors.infoLight,
          Icons.smart_toy_outlined,
        ),
      NotificationType.priceDrop => (
          colors.warning,
          colors.warningLight,
          Icons.trending_down_outlined,
        ),
      NotificationType.newListing => (
          colors.success,
          colors.successLight,
          Icons.list_outlined,
        ),
      NotificationType.savedSearch => (
          colors.info,
          colors.infoLight,
          Icons.bookmark_outlined,
        ),
      NotificationType.newBlog => (
          colors.primary,
          colors.infoLight,
          Icons.article_outlined,
        ),
      NotificationType.contractSigned => (
          colors.success,
          colors.successLight,
          Icons.description_outlined,
        ),
    };
  }
}
