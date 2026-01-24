import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../widgets.dart';

/// Overview tab content for project detail screen.
class ProjectDetailOverviewTab extends StatelessWidget {
  final Project project;

  const ProjectDetailOverviewTab({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.p8.h),
          ApartmentsDonutChart(project: project),
          SizedBox(height: AppSizes.p16.h),
          AreaStatsCard(project: project),
          SizedBox(height: AppSizes.p16.h),
          _ProjectInfoCard(project: project),
          SizedBox(height: AppSizes.p32.h),
        ],
      ),
    );
  }
}

class _ProjectInfoCard extends StatelessWidget {
  final Project project;

  const _ProjectInfoCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'projects_info'.tr(),
            style: AppTextStyles.labelLarge.copyWith(
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          _InfoRow(label: 'projects_floors'.tr(), value: '${project.numberOfFloors} ta'),
          Divider(height: AppSizes.p24.h, color: borderColor),
          _InfoRow(label: 'projects_blocks'.tr(), value: '${project.numberOfBlocks} ta'),
          Divider(height: AppSizes.p24.h, color: borderColor),
          _InfoRow(label: 'projects_total_units'.tr(), value: '${project.totalUnits} ta'),
          Divider(height: AppSizes.p24.h, color: borderColor),
          _InfoRow(
            label: 'projects_completion'.tr(),
            value: project.completionDate ?? '-',
          ),
          if (project.builder != null) ...[
            Divider(height: AppSizes.p24.h, color: borderColor),
            _InfoRow(label: 'projects_builder'.tr(), value: project.builder!),
          ],
          Divider(height: AppSizes.p24.h, color: borderColor),
          _InfoRow(label: 'projects_location'.tr(), value: project.location),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.textTheme.titleMedium?.color,
            ),
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
