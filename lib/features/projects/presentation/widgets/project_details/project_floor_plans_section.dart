import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/project_detail_model.dart';
import 'project_details_colors.dart';

/// Horizontal scrollable section showing available floor plans.
class ProjectFloorPlansSection extends StatelessWidget {
  final List<FloorPlanModel> floorPlans;
  final ValueChanged<FloorPlanModel>? onFloorPlanTap;

  const ProjectFloorPlansSection({
    super.key,
    required this.floorPlans,
    this.onFloorPlanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Mavjud rejalashtirishlar',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: ProjectDetailsColors.textDark,
              fontFamily: 'Inter',
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: floorPlans.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final plan = floorPlans[index];
              return _FloorPlanCard(
                plan: plan,
                onTap: () => onFloorPlanTap?.call(plan),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FloorPlanCard extends StatelessWidget {
  final FloorPlanModel plan;
  final VoidCallback? onTap;

  const _FloorPlanCard({
    required this.plan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
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
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: ProjectDetailsColors.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  '${plan.rooms}x',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: ProjectDetailsColors.primaryBlue,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              plan.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ProjectDetailsColors.textDark,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              plan.area,
              style: TextStyle(
                fontSize: 12.sp,
                color: ProjectDetailsColors.textSecondary,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
