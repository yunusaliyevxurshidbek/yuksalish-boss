import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'project_details_colors.dart';

/// Progress section showing construction and sales progress bars.
class ProjectProgressSection extends StatelessWidget {
  final int constructionProgress;
  final int soldUnits;
  final int totalUnits;

  const ProjectProgressSection({
    super.key,
    required this.constructionProgress,
    required this.soldUnits,
    required this.totalUnits,
  });

  double get salesProgress => soldUnits / totalUnits;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ProjectDetailsColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'projects_progress_status'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ProjectDetailsColors.textDark,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 20.h),
          _ProgressBar(
            label: 'projects_progress_construction'.tr(),
            value: constructionProgress / 100,
            displayValue: '$constructionProgress%',
            color: ProjectDetailsColors.statusGreen,
          ),
          SizedBox(height: 20.h),
          _ProgressBar(
            label: 'projects_progress_sales'.tr(),
            value: salesProgress,
            displayValue: 'projects_progress_units'.tr(args: ['$soldUnits', '$totalUnits']),
            color: ProjectDetailsColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final String displayValue;
  final Color color;

  const _ProgressBar({
    required this.label,
    required this.value,
    required this.displayValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: ProjectDetailsColors.textSecondary,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: ProjectDetailsColors.progressBackground,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10.h,
          ),
        ),
      ],
    );
  }
}
