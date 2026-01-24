import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';

class AnalyticsKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final double? trend;
  final bool isNegativeBetter;

  const AnalyticsKpiCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
    this.isNegativeBetter = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    final trendValue = trend;
    final hasTrend = trendValue != null;
    final isPositive = (trendValue ?? 0) >= 0;
    final isGoodTrend = isNegativeBetter ? !isPositive : isPositive;

    return Container(
      width: 180.w,
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AnalyticsRadius.card.r),
        boxShadow: [colors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Icon + Title/Subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconContainer(),
              SizedBox(width: 12.w),
              Expanded(child: _buildTitleSection(context)),
            ],
          ),
          SizedBox(height: 16.h),

          // Row 2: Value
          _buildValueText(colors),

          // Row 3: Trend Pill (if present)
          if (hasTrend) ...[
            SizedBox(height: 12.h),
            _buildTrendPill(trendValue, isPositive, isGoodTrend, colors),
          ],
        ],
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AnalyticsRadius.medium.r),
      ),
      child: Icon(
        icon,
        color: color,
        size: 22.w,
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelSmall.copyWith(
            color: colors.textSubtitle,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            height: 1.3,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 2.h),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: colors.textMuted,
              fontSize: 10.sp,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildValueText(AnalyticsPremiumColors colors) {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: AppTextStyles.metricMedium.copyWith(
            color: colors.textHeading,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendPill(
    double trendValue,
    bool isPositive,
    bool isGoodTrend,
    AnalyticsPremiumColors colors,
  ) {
    final trendColor = isGoodTrend
        ? colors.success
        : colors.danger;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AnalyticsRadius.chip.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: 14.w,
            color: trendColor,
          ),
          SizedBox(width: 4.w),
          Text(
            '${isPositive ? '+' : ''}${trendValue.toStringAsFixed(1)}%',
            style: AppTextStyles.labelSmall.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
