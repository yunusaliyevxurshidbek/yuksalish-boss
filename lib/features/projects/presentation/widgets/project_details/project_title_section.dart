import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'project_details_colors.dart';

/// Title section with project name, location, and status badge.
class ProjectTitleSection extends StatelessWidget {
  final String name;
  final String location;
  final String status;

  const ProjectTitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.status,
  });

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
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: ProjectDetailsColors.textDark,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              _StatusBadge(status: status),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18.w,
                color: ProjectDetailsColors.textSecondary,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ProjectDetailsColors.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, textColor, statusText) = _getStatusConfig();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  (Color, Color, String) _getStatusConfig() {
    switch (status) {
      case 'building':
        return (
          ProjectDetailsColors.statusOrange.withValues(alpha: 0.15),
          ProjectDetailsColors.statusOrange,
          'projects_status_building'.tr(),
        );
      case 'completed':
        return (
          ProjectDetailsColors.statusGreen.withValues(alpha: 0.15),
          ProjectDetailsColors.statusGreen,
          'projects_status_completed'.tr(),
        );
      default:
        return (
          ProjectDetailsColors.primaryBlue.withValues(alpha: 0.15),
          ProjectDetailsColors.primaryBlue,
          'projects_status_on_sale'.tr(),
        );
    }
  }
}
