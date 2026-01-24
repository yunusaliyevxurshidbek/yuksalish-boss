import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/payment_stats.dart';

/// 2x2 grid of payment statistics cards
class PaymentStatsCards extends StatelessWidget {
  const PaymentStatsCards({
    super.key,
    required this.stats,
  });

  final PaymentStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'finance_total_received'.tr(),
                value: '${stats.formattedTotalReceived} UZS',
                subtitle: 'finance_received_this_month'.tr(args: ['${stats.receivedThisMonth}']),
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColors.success,
                iconBgColor: AppColors.successLight,
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: _StatCard(
                title: 'finance_pending'.tr(),
                value: '${stats.formattedPendingPayments} UZS',
                subtitle: 'finance_pending_count'.tr(args: ['${stats.pendingCount}']),
                icon: Icons.schedule_rounded,
                iconColor: AppColors.warning,
                iconBgColor: AppColors.warningLight,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.p12.h),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'finance_overdue'.tr(),
                value: '${stats.formattedOverduePayments} UZS',
                subtitle: 'finance_overdue_count'.tr(args: ['${stats.overdueCount}']),
                subtitleColor: AppColors.error,
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.error,
                iconBgColor: AppColors.errorLight,
              ),
            ),
            SizedBox(width: AppSizes.p12.w),
            Expanded(
              child: _StatCard(
                title: 'finance_total_transactions'.tr(),
                value: '${stats.totalTransactions} ta',
                subtitle: 'finance_total_label'.tr(),
                icon: Icons.receipt_long_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.infoLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.subtitleColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.p8.w),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: AppSizes.iconM.w,
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.p4.h),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.p4.h),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: subtitleColor ?? theme.textTheme.bodySmall?.color,
              fontWeight: subtitleColor != null ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
