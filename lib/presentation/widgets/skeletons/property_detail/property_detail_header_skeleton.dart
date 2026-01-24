import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../shimmer_wrapper.dart';

/// Skeleton for property detail image header.
class PropertyDetailHeaderSkeleton extends StatelessWidget {
  const PropertyDetailHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerBaseColor = isDark ? AppColors.darkBorder : AppColors.grey100;

    return ShimmerWrapper(
      child: Stack(
        children: [
          Container(
            height: 300.h,
            width: double.infinity,
            color: shimmerBaseColor,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleButtonSkeleton(color: shimmerBaseColor),
                Row(
                  children: [
                    _CircleButtonSkeleton(color: shimmerBaseColor),
                    SizedBox(width: 8.w),
                    _CircleButtonSkeleton(color: shimmerBaseColor),
                    SizedBox(width: 8.w),
                    _CircleButtonSkeleton(color: shimmerBaseColor),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 24.h,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButtonSkeleton extends StatelessWidget {
  final Color color;

  const _CircleButtonSkeleton({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
