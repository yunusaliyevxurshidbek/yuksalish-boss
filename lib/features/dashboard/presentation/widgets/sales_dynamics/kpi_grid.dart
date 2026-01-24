import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/sales_dynamics_models.dart';

/// Grid of KPI metric cards.
class KpiGrid extends StatelessWidget {
  final List<KpiMetric> metrics;

  const KpiGrid({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) => _KpiCard(metric: metrics[index]),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final KpiMetric metric;

  const _KpiCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final trendColor =
        metric.isPositive ? AppColors.salesSuccess : AppColors.salesError;
    final trendBackground =
        metric.isPositive ? AppColors.salesSuccessLight : AppColors.salesErrorLight;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.salesCard,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.salesShadow.withValues(alpha: 0.06),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: metric.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              metric.icon,
              size: 18.w,
              color: metric.accentColor,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            metric.label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.salesTextSecondary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            metric.value,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.salesTextPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: trendBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  metric.isPositive ? Icons.trending_up : Icons.trending_down,
                  size: 12.w,
                  color: trendColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  metric.change,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: trendColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
