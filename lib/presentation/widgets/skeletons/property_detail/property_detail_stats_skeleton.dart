import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

/// Skeleton for stats section.
class StatsSectionSkeleton extends StatelessWidget {
  const StatsSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: shimmerColor, width: 1),
          bottom: BorderSide(color: shimmerColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItemSkeleton(shimmerColor: shimmerColor),
          Container(height: 40.h, width: 1, color: shimmerColor),
          _StatItemSkeleton(shimmerColor: shimmerColor),
          Container(height: 40.h, width: 1, color: shimmerColor),
          _StatItemSkeleton(shimmerColor: shimmerColor),
        ],
      ),
    );
  }
}

class _StatItemSkeleton extends StatelessWidget {
  final Color shimmerColor;

  const _StatItemSkeleton({required this.shimmerColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 6.w),
            Container(
              width: 30.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Container(
          width: 40.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}

/// Helper function to get theme-aware shimmer color.
Color _getShimmerColor(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return isDark ? AppColors.darkBorder : AppColors.grey100;
}
