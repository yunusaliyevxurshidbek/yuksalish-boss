import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../bloc/revenue_details_state.dart';

class RevenueDetailsPaymentBreakdown extends StatelessWidget {
  final RevenueStats stats;

  const RevenueDetailsPaymentBreakdown({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalPayments = stats.totalPaid + stats.pendingPayments + stats.overduePayments;
    final paidPercent = totalPayments > 0 ? (stats.totalPaid / totalPayments) : 0.0;
    final pendingPercent = totalPayments > 0 ? (stats.pendingPayments / totalPayments) : 0.0;
    final overduePercent = totalPayments > 0 ? (stats.overduePayments / totalPayments) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'revenue_payment_breakdown'.tr(),
          style: AppTextStyles.h4.copyWith(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        Container(
          padding: EdgeInsets.all(AppSizes.p20.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              width: AppSizes.borderThin,
            ),
          ),
          child: Column(
            children: [
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: SizedBox(
                  height: 12.h,
                  child: Row(
                    children: [
                      if (paidPercent > 0)
                        Expanded(
                          flex: (paidPercent * 100).round(),
                          child: Container(color: AppColors.success),
                        ),
                      if (pendingPercent > 0)
                        Expanded(
                          flex: (pendingPercent * 100).round(),
                          child: Container(color: AppColors.warning),
                        ),
                      if (overduePercent > 0)
                        Expanded(
                          flex: (overduePercent * 100).round(),
                          child: Container(color: AppColors.error),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizes.p20.h),
              // Legend
              RevenuePaymentItem(
                color: AppColors.success,
                label: 'finance_paid'.tr(),
                amount: stats.totalPaid,
                percent: paidPercent,
              ),
              SizedBox(height: AppSizes.p12.h),
              RevenuePaymentItem(
                color: AppColors.warning,
                label: 'finance_expected'.tr(),
                amount: stats.pendingPayments,
                percent: pendingPercent,
              ),
              SizedBox(height: AppSizes.p12.h),
              RevenuePaymentItem(
                color: AppColors.error,
                label: 'finance_overdue'.tr(),
                amount: stats.overduePayments,
                percent: overduePercent,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RevenuePaymentItem extends StatelessWidget {
  final Color color;
  final String label;
  final double amount;
  final double percent;

  const RevenuePaymentItem({
    super.key,
    required this.color,
    required this.label,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: AppSizes.p12.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
        Text(
          amount.currencyShort,
          style: AppTextStyles.labelLarge.copyWith(
            color: theme.textTheme.titleMedium?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: AppSizes.p8.w),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
          ),
          child: Text(
            '${(percent * 100).toStringAsFixed(0)}%',
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
