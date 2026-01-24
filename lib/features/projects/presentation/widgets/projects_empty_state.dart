import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class ProjectsEmptyApartments extends StatelessWidget {
  const ProjectsEmptyApartments({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor.withAlpha(100)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.apartment_rounded,
            size: 48.w,
            color: theme.textTheme.bodySmall?.color,
          ),
          SizedBox(height: 16.h),
          Text(
            'projects_empty'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'projects_empty_filter'.tr(),
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
