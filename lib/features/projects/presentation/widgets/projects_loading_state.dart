import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import 'project_carousel.dart';

class ProjectsLoadingState extends StatelessWidget {
  const ProjectsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Filter chips skeleton
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Container(
                  height: 36.h,
                  margin: EdgeInsets.only(right: index < 3 ? 8.w : 0),
                  decoration: BoxDecoration(
                    color: shimmerColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Carousel skeleton
          const ProjectCarouselSkeleton(),
          SizedBox(height: 24.h),
          // Header skeleton
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: shimmerColor.withAlpha(50),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 16.h),
          // List skeleton
          ...List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: shimmerColor.withAlpha(50),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApartmentsLoadingSkeleton extends StatelessWidget {
  final bool isGridView;

  const ApartmentsLoadingSkeleton({super.key, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    if (isGridView) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.75,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: shimmerColor.withAlpha(50),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: Container(
            height: 100.h,
            decoration: BoxDecoration(
              color: shimmerColor.withAlpha(50),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ),
    );
  }
}
