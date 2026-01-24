import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'project_details_colors.dart';

/// Statistics grid showing key project metrics in 2x2 layout.
class ProjectStatisticsGrid extends StatelessWidget {
  final String deliveryDate;
  final String startPrice;
  final int totalUnits;
  final String ceilingHeight;

  const ProjectStatisticsGrid({
    super.key,
    required this.deliveryDate,
    required this.startPrice,
    required this.totalUnits,
    required this.ceilingHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _StatCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'projects_stats_delivery_date'.tr(),
                  value: deliveryDate,
                  iconColor: ProjectDetailsColors.primaryBlue,
                ),
                SizedBox(height: 12.h),
                _StatCard(
                  icon: Icons.straighten_outlined,
                  label: 'projects_stats_starting_price'.tr(),
                  value: '$startPrice / m\u00B2',
                  iconColor: ProjectDetailsColors.statusGreen,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              children: [
                _StatCard(
                  icon: Icons.apartment_outlined,
                  label: 'projects_stats_units'.tr(),
                  value: '$totalUnits ta',
                  iconColor: ProjectDetailsColors.statusOrange,
                ),
                SizedBox(height: 12.h),
                _StatCard(
                  icon: Icons.height_outlined,
                  label: 'projects_stats_ceiling_height'.tr(),
                  value: ceilingHeight,
                  iconColor: const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20.w,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: ProjectDetailsColors.textSecondary,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: ProjectDetailsColors.textDark,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
