import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../data/models/payment_stats.dart';

/// Horizontally scrollable payment KPI cards
class PaymentKpiCards extends StatelessWidget {
  const PaymentKpiCards({
    super.key,
    required this.stats,
    this.isLoading = false,
  });

  final PaymentStats stats;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer(context);
    }

    return SizedBox(
      height: 140.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: [
          _KpiCard(
            title: 'finance_total_received'.tr(),
            value: stats.formattedTotalReceived,
            subtitle: 'finance_received_this_month'.tr(args: ['${stats.receivedThisMonth}']),
            iconSvg: AppIcons.money,
            iconColor: AppColors.success,
            iconBgColor: AppColors.successLight,
          ),
          SizedBox(width: AppSizes.p12.w),
          _KpiCard(
            title: 'finance_pending'.tr(),
            value: stats.formattedPendingPayments,
            subtitle: 'finance_pending_amount'.tr(args: ['${stats.pendingCount}']),
            iconSvg: AppIcons.clock,
            iconColor: AppColors.warning,
            iconBgColor: AppColors.warningLight,
          ),
          SizedBox(width: AppSizes.p12.w),
          _KpiCard(
            title: 'finance_overdue'.tr(),
            value: stats.formattedOverduePayments,
            subtitle: '${stats.overdueCount} ta',
            subtitleColor: AppColors.error,
            iconSvg: AppIcons.warning,
            iconColor: AppColors.error,
            iconBgColor: AppColors.errorLight,
          ),
          SizedBox(width: AppSizes.p12.w),
          _KpiCard(
            title: 'finance_total_transactions'.tr(),
            value: '${stats.totalTransactions}',
            subtitle: 'finance_total_label'.tr(),
            iconSvg: AppIcons.layers,
            iconColor: AppColors.primary,
            iconBgColor: AppColors.infoLight,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return SizedBox(
      height: 140.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: AppSizes.p12.w),
        itemBuilder: (_, __) => AppShimmer(
          child: Container(
            width: 160.w,
            padding: EdgeInsets.all(AppSizes.p16.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 100.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: AppSizes.p4.h),
                Container(
                  width: 60.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.iconSvg,
    required this.iconColor,
    required this.iconBgColor,
    this.subtitleColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final String iconSvg;
  final Color iconColor;
  final Color iconBgColor;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      width: 160.w,
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
          // Icon
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            ),
            child: Center(
              child: SvgPicture.string(
                iconSvg,
                width: 18.w,
                height: 18.w,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          const Spacer(),
          // Title
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSizes.p4.h),
          // Value
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
          // Subtitle
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: subtitleColor ?? theme.textTheme.bodySmall?.color,
              fontWeight: subtitleColor != null ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
