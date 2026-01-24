import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import 'shimmer_wrapper.dart';

/// Skeleton loader for news carousel.
class NewsCarouselSkeleton extends StatelessWidget {
  const NewsCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerBaseColor = isDark ? AppColors.darkBorder : AppColors.grey100;

    return ShimmerWrapper(
      child: Container(
        height: 180.h,
        decoration: BoxDecoration(
          color: shimmerBaseColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            // Gradient overlay placeholder
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(
                      height: 20.h,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: shimmerBaseColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Excerpt placeholder
                    Container(
                      height: 14.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: shimmerBaseColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
