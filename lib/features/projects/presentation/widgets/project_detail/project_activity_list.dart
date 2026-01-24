import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';

/// Activity item data model.
class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final BadgeType type;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
  });
}

/// Recent activity list for project detail.
class ProjectActivityList extends StatelessWidget {
  final List<ActivityItem> items;
  final VoidCallback? onViewAll;

  const ProjectActivityList({
    super.key,
    required this.items,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "So'nggi faoliyat",
          actionText: 'Barchasi',
          onActionTap: onViewAll,
        ),
        SizedBox(height: AppSizes.p12.h),
        ...items.map((item) => _ActivityItemCard(item: item)),
      ],
    );
  }
}

class _ActivityItemCard extends StatelessWidget {
  final ActivityItem item;

  const _ActivityItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.p16.w,
        vertical: AppSizes.p4.h,
      ),
      padding: EdgeInsets.all(AppSizes.p12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.time,
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
