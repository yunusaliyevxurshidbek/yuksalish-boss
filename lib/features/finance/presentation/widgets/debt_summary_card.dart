import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/debt_stats.dart';

/// Warning-style summary card for debt statistics
class DebtSummaryCard extends StatelessWidget {
  const DebtSummaryCard({
    super.key,
    required this.stats,
  });

  final DebtStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        gradient: AppColors.warningGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: AppSizes.iconL.w,
              ),
              SizedBox(width: AppSizes.p8.w),
              Text(
                'finance_total_debt'.tr(),
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          // Total debt amount
          Text(
            '${stats.formattedTotalDebt} UZS',
            style: AppTextStyles.metricLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          SizedBox(height: AppSizes.p16.h),
          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.calendar_today_rounded,
                  label: 'finance_overdue'.tr(),
                  value: '${stats.formattedOverdueAmount} UZS',
                ),
              ),
              SizedBox(width: AppSizes.p16.w),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.people_rounded,
                  label: 'finance_debtors_count'.tr(),
                  value: '${stats.debtorsCount} ta',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: AppSizes.iconM.w,
        ),
        SizedBox(width: AppSizes.p8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: AppSizes.p4.h),
              Text(
                value,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
