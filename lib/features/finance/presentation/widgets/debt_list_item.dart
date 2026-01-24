import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/debt.dart';

/// List item widget for displaying a debtor record with progress
class DebtListItem extends StatelessWidget {
  const DebtListItem({
    super.key,
    required this.debt,
    this.onTap,
  });

  final Debt debt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.p12.h),
        padding: EdgeInsets.all(AppSizes.p16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          border: Border.all(
            color: borderColor,
            width: AppSizes.borderThin,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: name and overdue badge
            Row(
              children: [
                // Avatar
                Container(
                  width: AppSizes.avatarM.w,
                  height: AppSizes.avatarM.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(debt.clientName),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.p12.w),
                // Name and contract
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt.clientName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.textTheme.titleMedium?.color,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSizes.p4.h),
                      Text(
                        '${debt.contractNumber} • ${debt.apartmentNumber}',
                        style: AppTextStyles.caption.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                // Overdue badge
                _buildOverdueBadge(),
              ],
            ),
            SizedBox(height: AppSizes.p16.h),
            // Progress section
            _buildProgressSection(context),
            SizedBox(height: AppSizes.p16.h),
            // Amount info
            _buildAmountInfo(context),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildOverdueBadge() {
    final (color, bgColor) = switch (debt.severityLevel) {
      0 => (AppColors.success, AppColors.successLight),
      1 => (AppColors.warning, AppColors.warningLight),
      _ => (AppColors.error, AppColors.errorLight),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p8.w,
        vertical: AppSizes.p4.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            debt.overdueDays > 0
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline_rounded,
            size: 12.w,
            color: color,
          ),
          SizedBox(width: AppSizes.p4.w),
          Text(
            debt.overdueDays > 0
                ? 'finance_days_overdue'.tr(namedArgs: {'days': debt.overdueDays.toString()})
                : 'finance_on_time'.tr(),
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBorder : AppColors.border;
    final progressColor = _getProgressColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          child: LinearProgressIndicator(
            value: debt.paidPercentage / 100,
            backgroundColor: bgColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8.h,
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        // Progress text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'finance_paid_percent'.tr(namedArgs: {'percent': debt.paidPercentage.toStringAsFixed(1)}),
              style: AppTextStyles.caption.copyWith(
                color: progressColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'finance_remaining_percent'.tr(namedArgs: {'percent': (100 - debt.paidPercentage).toStringAsFixed(1)}),
              style: AppTextStyles.caption.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getProgressColor() {
    if (debt.paidPercentage >= 80) {
      return AppColors.success;
    } else if (debt.paidPercentage >= 50) {
      return AppColors.info;
    } else if (debt.paidPercentage >= 30) {
      return AppColors.warning;
    }
    return AppColors.error;
  }

  Widget _buildAmountInfo(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.divider;

    return Row(
      children: [
        Expanded(
          child: _buildAmountColumn(
            context: context,
            label: 'finance_total_debt'.tr(),
            value: debt.formattedTotalAmount,
            color: theme.textTheme.titleMedium?.color ?? AppColors.textPrimary,
          ),
        ),
        Container(
          width: 1,
          height: 40.h,
          color: dividerColor,
        ),
        Expanded(
          child: _buildAmountColumn(
            context: context,
            label: 'finance_remaining_debt_label'.tr(),
            value: debt.formattedRemainingAmount,
            color: AppColors.error,
          ),
        ),
        if (debt.overdueAmount > 0) ...[
          Container(
            width: 1,
            height: 40.h,
            color: dividerColor,
          ),
          Expanded(
            child: _buildAmountColumn(
              context: context,
              label: "finance_overdue".tr(),
              value: debt.formattedOverdueAmount,
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAmountColumn({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p8.w),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.p4.h),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
