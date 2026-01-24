import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/analytics_summary.dart';
import '../bloc/analytics_bloc.dart';

/// Summary card with gradient background for analytics
class AnalyticsSummaryCard extends StatelessWidget {
  const AnalyticsSummaryCard({
    super.key,
    required this.summary,
    required this.selectedTab,
  });

  final AnalyticsSummary summary;
  final AnalyticsTab selectedTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return switch (selectedTab) {
      AnalyticsTab.sales => _buildSalesContent(),
      AnalyticsTab.finance => _buildFinanceContent(),
      AnalyticsTab.leads => _buildLeadsContent(),
    };
  }

  Widget _buildSalesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'analytics_ytd_revenue'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        Text(
          '${summary.formattedYtdRevenue} UZS',
          style: AppTextStyles.metricLarge.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        Row(
          children: [
            _buildStatItem(
              'analytics_deals_closed_count'.tr(namedArgs: {'count': '${summary.closedDeals}'}),
            ),
            SizedBox(width: AppSizes.p24.w),
            _buildChangeIndicator(summary.revenueChange),
          ],
        ),
      ],
    );
  }

  Widget _buildFinanceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'analytics_financial_metrics'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        Row(
          children: [
            Expanded(
              child: _buildFinanceItem(
                'analytics_income'.tr(),
                _formatAmount(summary.totalIncome),
                true,
              ),
            ),
            SizedBox(width: AppSizes.p16.w),
            Expanded(
              child: _buildFinanceItem(
                'analytics_expenses'.tr(),
                _formatAmount(summary.totalExpenses),
                false,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.p12.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p12.w,
            vertical: AppSizes.p8.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.textOnPrimary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: AppColors.textOnPrimary,
                size: AppSizes.iconM.w,
              ),
              SizedBox(width: AppSizes.p8.w),
              Text(
                'analytics_net_profit'.tr(namedArgs: {'amount': _formatAmount(summary.netIncome)}),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeadsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'analytics_lead_statistics'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: AppSizes.p8.h),
        Text(
          'analytics_leads_count'.tr(namedArgs: {'count': '${summary.totalLeads}'}),
          style: AppTextStyles.metricLarge.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        Row(
          children: [
            _buildStatItem(
              '${summary.overallConversion.toStringAsFixed(1)}% ${'analytics_conversion_label'.tr()}',
            ),
            SizedBox(width: AppSizes.p24.w),
            _buildChangeIndicator(summary.dealsChange),
          ],
        ),
      ],
    );
  }

  Widget _buildFinanceItem(String label, String value, bool isIncome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textOnPrimary.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: AppSizes.p4.h),
        Text(
          '$value UZS',
          style: AppTextStyles.metricSmall.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String text) {
    return Text(
      text,
      style: AppTextStyles.metricSmall.copyWith(
        color: AppColors.textOnPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildChangeIndicator(double change) {
    final isPositive = change >= 0;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p8.w,
        vertical: AppSizes.p4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            color: AppColors.textOnPrimary,
            size: AppSizes.iconS.w,
          ),
          SizedBox(width: 2.w),
          Text(
            '${isPositive ? '+' : ''}${change.toStringAsFixed(1)}%',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} mln';
    }
    return amount.toStringAsFixed(0);
  }
}
