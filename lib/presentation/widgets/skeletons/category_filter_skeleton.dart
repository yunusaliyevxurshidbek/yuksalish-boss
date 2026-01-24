import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import 'shimmer_wrapper.dart';

/// Category filter chips skeleton.
class CategoryFilterSkeleton extends StatelessWidget {
  final int chipCount;

  const CategoryFilterSkeleton({super.key, this.chipCount = 5});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerBaseColor = isDark ? AppColors.darkBorder : AppColors.grey100;

    return ShimmerWrapper(
      child: SizedBox(
        height: 40.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: chipCount,
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            return Container(
              width: index == 0 ? 50.w : 80.w,
              decoration: BoxDecoration(
                color: shimmerBaseColor,
                borderRadius: BorderRadius.circular(25.r),
              ),
            );
          },
        ),
      ),
    );
  }
}
