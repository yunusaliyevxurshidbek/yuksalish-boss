import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class ProjectsPaginationInfo extends StatelessWidget {
  final int showing;
  final int total;
  final bool hasMore;

  const ProjectsPaginationInfo({
    super.key,
    required this.showing,
    required this.total,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'projects_pagination_showing'.tr(namedArgs: {'showing': '$showing', 'total': '$total'}),
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          if (hasMore) ...[
            SizedBox(width: 8.w),
            const Text(
              '\u2022',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(width: 8.w),
            Text(
              'projects_load_more'.tr(),
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
