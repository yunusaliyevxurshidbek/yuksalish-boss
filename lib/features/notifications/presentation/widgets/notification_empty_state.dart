import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../theme/notifications_theme.dart';

class NotificationEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const NotificationEmptyState({
    super.key,
    this.title = 'notifications_empty_title',
    this.subtitle = 'notifications_empty_subtitle',
  });

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96.w,
              height: 96.w,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.border,
                  width: 1.w,
                ),
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 40.w,
                color: colors.textMuted,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              title.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
