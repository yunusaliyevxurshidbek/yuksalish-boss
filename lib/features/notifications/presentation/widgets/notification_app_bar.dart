import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../theme/notifications_theme.dart';

/// Menu actions for notifications app bar.
enum NotificationMenuAction {
  markAllRead,
  clearAll,
}

/// App bar for notifications screen with badge and menu.
class NotificationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int unreadCount;
  final Animation<double> badgeScale;
  final ValueChanged<NotificationMenuAction> onMenuAction;

  const NotificationAppBar({
    super.key,
    required this.unreadCount,
    required this.badgeScale,
    required this.onMenuAction,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);
    return AppBar(
      backgroundColor: colors.surface,
      surfaceTintColor: colors.surface,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_rounded,
          color: colors.textPrimary,
          size: 20.w,
        ),
      ),
      title: Text(
        'notifications_title'.tr(),
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
      actions: [
        _BadgeAction(
          unreadCount: unreadCount,
          badgeScale: badgeScale,
        ),
        PopupMenuButton<NotificationMenuAction>(
          icon: Icon(
            Icons.more_vert,
            color: colors.textPrimary,
            size: 20.w,
          ),
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: colors.border, width: 1.w),
          ),
          onSelected: onMenuAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: NotificationMenuAction.markAllRead,
              child: Text(
                'notifications_menu_mark_all_read'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: colors.textPrimary,
                ),
              ),
            ),
            PopupMenuItem(
              value: NotificationMenuAction.clearAll,
              child: Text(
                'notifications_menu_clear_all'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: colors.error,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}

class _BadgeAction extends StatelessWidget {
  final int unreadCount;
  final Animation<double> badgeScale;

  const _BadgeAction({
    required this.unreadCount,
    required this.badgeScale,
  });

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: colors.textPrimary,
              size: 22.w,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 8.w,
              top: 8.h,
              child: ScaleTransition(
                scale: badgeScale,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: colors.error,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
