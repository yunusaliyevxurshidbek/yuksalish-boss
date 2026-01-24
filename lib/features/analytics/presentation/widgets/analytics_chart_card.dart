import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../theme/analytics_theme.dart';

/// Premium card container for analytics charts.
/// Features soft shadows and rounded corners for fintech dashboard aesthetic.
class AnalyticsChartCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AnalyticsChartCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      padding: padding ?? EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AnalyticsRadius.card.r),
        boxShadow: [colors.cardShadow],
      ),
      child: child,
    );
  }
}
