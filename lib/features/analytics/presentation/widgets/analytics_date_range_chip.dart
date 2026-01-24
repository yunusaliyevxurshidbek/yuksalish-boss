import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/repositories/analytics_repository.dart';

/// Date range chip for analytics filtering.
class AnalyticsDateRangeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AnalyticsDateRangeChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? AppColors.textOnPrimary
                : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Helper to get label for date range.
String getDateRangeLabel(AnalyticsDateRange range) {
  return switch (range) {
    AnalyticsDateRange.thisMonth => 'analytics_date_range_this_month'.tr(),
    AnalyticsDateRange.lastMonth => 'analytics_date_range_last_month'.tr(),
    AnalyticsDateRange.thisQuarter => 'analytics_date_range_quarter'.tr(),
    AnalyticsDateRange.thisYear => 'analytics_date_range_year'.tr(),
    AnalyticsDateRange.custom => 'analytics_date_range_custom'.tr(),
  };
}
