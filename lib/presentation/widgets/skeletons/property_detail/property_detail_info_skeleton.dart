import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

/// Skeleton for status badge.
class StatusBadgeSkeleton extends StatelessWidget {
  const StatusBadgeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Container(
      height: 28.h,
      width: 80.w,
      decoration: BoxDecoration(
        color: shimmerColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}

/// Skeleton for title.
class TitleSkeleton extends StatelessWidget {
  const TitleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Container(
      height: 28.h,
      width: 250.w,
      decoration: BoxDecoration(
        color: shimmerColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

/// Skeleton for builder link.
class BuilderLinkSkeleton extends StatelessWidget {
  const BuilderLinkSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Container(
      height: 16.h,
      width: 120.w,
      decoration: BoxDecoration(
        color: shimmerColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

/// Skeleton for location text.
class LocationSkeleton extends StatelessWidget {
  const LocationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Container(
      height: 16.h,
      width: 180.w,
      decoration: BoxDecoration(
        color: shimmerColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

/// Skeleton for price section.
class PriceSectionSkeleton extends StatelessWidget {
  const PriceSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: shimmerColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 12.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 32.h,
                width: 140.w,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
          Container(
            height: 16.h,
            width: 80.w,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to get theme-aware shimmer color.
Color _getShimmerColor(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return isDark ? AppColors.darkBorder : AppColors.grey100;
}
