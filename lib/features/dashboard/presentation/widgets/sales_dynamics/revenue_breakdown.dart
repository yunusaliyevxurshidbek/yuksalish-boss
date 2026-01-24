import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_colors.dart';
import 'summary_cards.dart';

/// Revenue breakdown progress bar section
class RevenueBreakdownSection extends StatelessWidget {
  final double totalPaid;
  final double pendingPayments;
  final double overduePayments;

  const RevenueBreakdownSection({
    super.key,
    required this.totalPaid,
    required this.pendingPayments,
    required this.overduePayments,
  });

  double get total => totalPaid + pendingPayments + overduePayments;

  double get paidPercent => total > 0 ? (totalPaid / total * 100) : 0;
  double get pendingPercent => total > 0 ? (pendingPayments / total * 100) : 0;
  double get overduePercent => total > 0 ? (overduePayments / total * 100) : 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dashboard_revenue_breakdown'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 16.h),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 16.h,
              child: Row(
                children: [
                  if (paidPercent > 0)
                    Expanded(
                      flex: paidPercent.round(),
                      child: Container(color: AppColors.salesSuccess),
                    ),
                  if (pendingPercent > 0)
                    Expanded(
                      flex: pendingPercent.round(),
                      child: Container(color: AppColors.salesWarning),
                    ),
                  if (overduePercent > 0)
                    Expanded(
                      flex: overduePercent.round(),
                      child: Container(color: AppColors.salesError),
                    ),
                  if (total == 0)
                    Expanded(
                      child: Container(color: borderColor),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Legend
          _RevenueItem(
            color: AppColors.salesSuccess,
            label: 'dashboard_revenue_paid'.tr(),
            amount: totalPaid,
            percent: paidPercent,
            theme: theme,
          ),
          SizedBox(height: 10.h),
          _RevenueItem(
            color: AppColors.salesWarning,
            label: 'dashboard_revenue_pending'.tr(),
            amount: pendingPayments,
            percent: pendingPercent,
            theme: theme,
          ),
          SizedBox(height: 10.h),
          _RevenueItem(
            color: AppColors.salesError,
            label: 'dashboard_revenue_overdue'.tr(),
            amount: overduePayments,
            percent: overduePercent,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _RevenueItem extends StatelessWidget {
  final Color color;
  final String label;
  final double amount;
  final double percent;
  final ThemeData theme;

  const _RevenueItem({
    required this.color,
    required this.label,
    required this.amount,
    required this.percent,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
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
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        Text(
          CurrencyFormatter.format(amount),
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '${percent.toStringAsFixed(0)}%',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
