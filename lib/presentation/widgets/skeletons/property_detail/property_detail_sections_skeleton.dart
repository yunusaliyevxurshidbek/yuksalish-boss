import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';

/// Helper function to get theme-aware shimmer color.
Color _getShimmerColor(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return isDark ? AppColors.darkBorder : AppColors.grey100;
}

/// Skeleton for about section.
class AboutSectionSkeleton extends StatelessWidget {
  const AboutSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20.h,
          width: 120.w,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 12.h),
        ...List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Container(
              height: 14.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Skeleton for payment terms section.
class PaymentTermsSectionSkeleton extends StatelessWidget {
  const PaymentTermsSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20.h,
          width: 130.w,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _PaymentCardSkeleton(shimmerColor: shimmerColor)),
            SizedBox(width: 12.w),
            Expanded(child: _PaymentCardSkeleton(shimmerColor: shimmerColor)),
            SizedBox(width: 12.w),
            Expanded(child: _PaymentCardSkeleton(shimmerColor: shimmerColor)),
          ],
        ),
      ],
    );
  }
}

class _PaymentCardSkeleton extends StatelessWidget {
  final Color shimmerColor;

  const _PaymentCardSkeleton({required this.shimmerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: shimmerColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Container(
            height: 12.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: shimmerColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 18.h,
            width: 40.w,
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

/// Skeleton for divider.
class DividerSkeleton extends StatelessWidget {
  const DividerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Container(
      height: 1,
      color: shimmerColor,
    );
  }
}

/// Skeleton for blocs section.
class BlocsSectionSkeleton extends StatelessWidget {
  const BlocsSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 56.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: shimmerColor),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 52.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ],
    );
  }
}

/// Skeleton for amenities section.
class AmenitiesSectionSkeleton extends StatelessWidget {
  const AmenitiesSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20.h,
          width: 90.w,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: List.generate(
            6,
            (index) => Container(
              height: 40.h,
              width: 100.w + (index % 3) * 20.w,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Skeleton for location map section.
class LocationMapSkeleton extends StatelessWidget {
  const LocationMapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerColor = _getShimmerColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 200.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
      ],
    );
  }
}
