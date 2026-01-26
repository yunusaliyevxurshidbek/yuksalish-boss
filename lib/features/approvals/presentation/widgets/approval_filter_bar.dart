import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/approvals_cubit.dart';

/// Horizontal scrollable filter bar for approval types
class ApprovalFilterBar extends StatelessWidget {
  final ApprovalTypeFilter selectedFilter;
  final ValueChanged<ApprovalTypeFilter> onFilterChanged;

  const ApprovalFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
        itemCount: ApprovalTypeFilter.values.length,
        separatorBuilder: (_, __) => SizedBox(width: AppSizes.p8.w),
        itemBuilder: (context, index) {
          final filter = ApprovalTypeFilter.values[index];
          final isSelected = filter == selectedFilter;
          return _FilterChip(
            label: _getFilterLabel(filter),
            emoji: _getFilterEmoji(filter),
            isSelected: isSelected,
            onTap: () => onFilterChanged(filter),
          );
        },
      ),
    );
  }

  String _getFilterLabel(ApprovalTypeFilter filter) {
    return switch (filter) {
      ApprovalTypeFilter.all => 'approvals_filter_all'.tr(),
      ApprovalTypeFilter.purchase => 'approvals_filter_purchase'.tr(),
      ApprovalTypeFilter.payment => 'approvals_filter_payment'.tr(),
      ApprovalTypeFilter.hr => 'approvals_filter_hr'.tr(),
      ApprovalTypeFilter.budget => 'approvals_filter_budget'.tr(),
      ApprovalTypeFilter.discount => 'approvals_filter_discount'.tr(),
      ApprovalTypeFilter.approved => 'approvals_filter_approved'.tr(),
    };
  }

  String _getFilterEmoji(ApprovalTypeFilter filter) {
    return switch (filter) {
      ApprovalTypeFilter.all => '●',
      ApprovalTypeFilter.purchase => '🛒',
      ApprovalTypeFilter.payment => '💰',
      ApprovalTypeFilter.hr => '👤',
      ApprovalTypeFilter.budget => '📊',
      ApprovalTypeFilter.discount => '🏷️',
      ApprovalTypeFilter.approved => '✅',
    };
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimaryColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p12.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(width: AppSizes.p4.w),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : textPrimaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
