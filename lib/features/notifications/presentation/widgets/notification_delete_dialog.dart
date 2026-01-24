import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../theme/notifications_theme.dart';

/// Confirmation dialog for deleting a notification.
class NotificationDeleteDialog extends StatelessWidget {
  const NotificationDeleteDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const NotificationDeleteDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);
    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        'notifications_delete_title'.tr(),
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
      content: Text(
        'notifications_delete_message'.tr(),
        style: TextStyle(
          fontSize: 13.sp,
          color: colors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          style: TextButton.styleFrom(
            foregroundColor: colors.textSecondary,
          ),
          child: Text(
            'common_cancel'.tr(),
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          style: TextButton.styleFrom(
            foregroundColor: colors.error,
          ),
          child: Text(
            'notifications_action_delete'.tr(),
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
      ],
    );
  }
}
