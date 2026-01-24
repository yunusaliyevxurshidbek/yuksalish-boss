import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../bloc/sales_dynamics_state.dart';

class CurrencyFormatter {
  static String format(double value, {String currency = 'UZS'}) {
    if (currency == 'USD') {
      if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
      if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
      return '\$$value';
    } else {
      if (value >= 1000000000) {
        return '${(value / 1000000000).toStringAsFixed(1)} ${'dashboard_unit_billion'.tr()}';
      }
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)} ${'dashboard_unit_million'.tr()}';
      }
      if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(0)} ${'dashboard_unit_thousand'.tr()}';
      }
      return '${value.toStringAsFixed(0)} UZS';
    }
  }
}

class SummaryCardsSection extends StatelessWidget {
  final SalesDynamicsState state;
  const SummaryCardsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8.w,
      mainAxisSpacing: 8.h,
      childAspectRatio: 1.4,
      children: [
        _SummaryCard(
          icon: Icons.account_balance_wallet_rounded,
          label: 'dashboard_metric_revenue'.tr(),
          value: CurrencyFormatter.format(state.totalRevenue),
          trend: state.revenueTrend,
          accentColor: AppColors.salesSuccess,
        ),
        _SummaryCard(
          icon: Icons.apartment_rounded,
          label: 'dashboard_metric_sold'.tr(),
          value: 'dashboard_count_suffix'.tr(namedArgs: {'count': '${state.apartmentsSold}'}),
          trend: state.apartmentsTrend,
          accentColor: AppColors.salesPrimary,
        ),
        _SummaryCard(
          icon: Icons.description_rounded,
          label: 'dashboard_closed_deals'.tr(),
          value: 'dashboard_count_suffix'.tr(namedArgs: {'count': '${state.completedContracts}'}),
          trend: 0, // No trend provided for this
          accentColor: AppColors.funnelContacted,
        ),
        _SummaryCard(
          icon: Icons.trending_up_rounded,
          label: 'dashboard_metric_conversion'.tr(),
          value: '${state.conversionRate.toStringAsFixed(1)}%',
          trend: state.conversionTrend,
          accentColor: AppColors.salesWarning,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double trend;
  final Color accentColor;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isPositive = trend >= 0;
    final trendColor = isPositive ? AppColors.salesSuccess : AppColors.salesError;
    final trendBackground = isPositive
        ? AppColors.salesSuccess.withValues(alpha: isDark ? 0.2 : 0.1)
        : AppColors.salesError.withValues(alpha: isDark ? 0.2 : 0.1);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: accentColor,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    if (trend != 0) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: trendBackground,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                              size: 12.w,
                              color: trendColor,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${trend.abs().toStringAsFixed(1)}%',
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: trendColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
