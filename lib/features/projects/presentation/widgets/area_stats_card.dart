import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/project.dart';

/// Card showing sold vs unsold units statistics.
class AreaStatsCard extends StatelessWidget {
  final Project project;

  const AreaStatsCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final soldPercentage = project.soldPercentage;
    final availablePercentage = 100 - soldPercentage;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'projects_sales_stats'.tr(),
            style: AppTextStyles.labelLarge.copyWith(
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            children: [
              Expanded(
                child: _buildProgress(
                  context: context,
                  label: 'projects_units_sold'.tr(),
                  value: project.soldUnits,
                  percentage: soldPercentage,
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: AppSizes.p16.w),
              Expanded(
                child: _buildProgress(
                  context: context,
                  label: 'projects_units_empty'.tr(),
                  value: project.availableUnits,
                  percentage: availablePercentage,
                  color: theme.textTheme.bodySmall?.color ?? AppColors.textTertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p16.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p12.w,
              vertical: AppSizes.p8.h,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'projects_total_units_label'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                Text(
                  '${project.totalUnits} ta',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress({
    required BuildContext context,
    required String label,
    required int value,
    required double percentage,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '$value ta',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        Stack(
          children: [
            Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: dividerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            FractionallySizedBox(
              widthFactor: (percentage / 100).clamp(0, 1),
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: AppTextStyles.caption.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
