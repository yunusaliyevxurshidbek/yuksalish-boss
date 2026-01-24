import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import 'project_data.dart';

/// Card widget for displaying project summary in the projects list screen.
class ProjectsListCard extends StatelessWidget {
  final ProjectData project;
  final VoidCallback onTap;

  const ProjectsListCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: AppSizes.p16.h),
            _buildMetrics(),
            SizedBox(height: AppSizes.p12.h),
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.name, style: AppTextStyles.h4),
              SizedBox(height: 4.h),
              Row(
                children: [
                  SvgPicture.string(
                    AppIcons.mapPin,
                    width: 14.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textTertiary,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      project.location,
                      style: AppTextStyles.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        StatusBadge(
          text: project.status,
          type: project.statusType,
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Row(
      children: [
        Expanded(
          child: _ProjectMetric(
            label: 'projects_units_sold'.tr(),
            value: '${project.soldUnits}/${project.totalUnits}',
          ),
        ),
        Expanded(
          child: _ProjectMetric(
            label: 'Qiymat',
            value: project.totalValue.short,
          ),
        ),
        Expanded(
          child: _ProjectMetric(
            label: 'Tayyor',
            value: '${project.completionPercent}%',
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = project.salesProgress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('projects_sales_progress'.tr(), style: AppTextStyles.caption),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6.h,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(
              progress >= 0.8
                  ? AppColors.success
                  : progress >= 0.5
                      ? AppColors.primary
                      : AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectMetric extends StatelessWidget {
  final String label;
  final String value;

  const _ProjectMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        SizedBox(height: 2.h),
        Text(value, style: AppTextStyles.labelLarge),
      ],
    );
  }
}
