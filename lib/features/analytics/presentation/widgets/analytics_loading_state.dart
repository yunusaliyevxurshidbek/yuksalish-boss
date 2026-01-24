import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../theme/analytics_theme.dart';

/// Loading shimmer state for analytics screen.
class AnalyticsLoadingState extends StatelessWidget {
  const AnalyticsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    final baseColor = colors.cardBorder;
    final highlightColor = colors.scaffoldBackground;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Column(
        children: [
          AppShimmer(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
              ),
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          SizedBox(
            height: 150.h,
            child: Row(
              children: [
                Expanded(
                  child: AppShimmer(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AppShimmer(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      margin: EdgeInsets.only(left: 8.w),
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          AppShimmer(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 220.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
              ),
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          AppShimmer(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              height: 220.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
