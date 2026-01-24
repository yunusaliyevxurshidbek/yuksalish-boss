import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../theme/notifications_theme.dart';

enum NotificationFilter {
  all,
  unread,
  important,
}

class NotificationFilterTabs extends StatelessWidget {
  final NotificationFilter selectedFilter;
  final ValueChanged<NotificationFilter> onChanged;

  const NotificationFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = NotificationThemeColors.of(context);
    final filters = <(NotificationFilter, String)>[
      (NotificationFilter.all, 'notifications_filter_all'),
      (NotificationFilter.unread, 'notifications_filter_unread'),
      (NotificationFilter.important, 'notifications_filter_important'),
    ];

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index].$1;
          final label = filters[index].$2;
          final isSelected = filter == selectedFilter;

          return GestureDetector(
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary
                    : colors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? colors.primary
                      : colors.border,
                  width: 1.w,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colors.primary
                              .withValues(alpha: colors.isDark ? 0.35 : 0.18),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ]
                    : null,
              ),
          child: Text(
            label.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
                  color: isSelected
                      ? colors.textOnPrimary
                      : colors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
