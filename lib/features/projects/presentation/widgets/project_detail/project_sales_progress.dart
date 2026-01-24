import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';

/// Sales progress data model.
class SalesProgressItem {
  final String label;
  final int sold;
  final int total;
  final Color color;

  const SalesProgressItem({
    required this.label,
    required this.sold,
    required this.total,
    required this.color,
  });

  double get progress => sold / total;
}

/// Sales progress section for project detail.
class ProjectSalesProgress extends StatelessWidget {
  final List<SalesProgressItem> items;
  final VoidCallback? onDetailTap;

  const ProjectSalesProgress({
    super.key,
    required this.items,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      children: [
        SectionHeader(
          title: 'projects_sales_progress'.tr(),
          actionText: 'projects_detail_action'.tr(),
          onActionTap: onDetailTap,
        ),
        SizedBox(height: AppSizes.p16.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
          padding: EdgeInsets.all(AppSizes.p16.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final item = entry.value;
              final isLast = entry.key == items.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.p12.h),
                child: _ProgressRow(item: item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final SalesProgressItem item;

  const _ProgressRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            item.label,
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 8.h,
              backgroundColor: item.color.withAlpha(51),
              valueColor: AlwaysStoppedAnimation(item.color),
            ),
          ),
        ),
        SizedBox(width: AppSizes.p12.w),
        SizedBox(
          width: 50.w,
          child: Text(
            '${item.sold}/${item.total}',
            style: AppTextStyles.labelSmall.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
