import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/project.dart';

/// Card widget for displaying project information in a list.
class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  SizedBox(height: AppSizes.p16.h),
                  _buildStatsRow(),
                  SizedBox(height: AppSizes.p16.h),
                  _buildProgressSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        gradient: _getGradientForProject(),
      ),
      child: Stack(
        children: [
          // Pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _PatternPainter(),
            ),
          ),
          // Status badge
          Positioned(
            top: AppSizes.p12.h,
            right: AppSizes.p12.w,
            child: _buildStatusBadge(),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientForProject() {
    switch (project.status) {
      case ProjectStatus.underConstruction:
      case ProjectStatus.active:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        );
      case ProjectStatus.completed:
      case ProjectStatus.ready:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.success, Color(0xFF4ADE80)],
        );
      case ProjectStatus.presale:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.info, AppColors.info.withAlpha(200)],
        );
      case ProjectStatus.suspended:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.textSecondary, AppColors.textSecondary.withAlpha(200)],
        );
    }
  }

  Widget _buildStatusBadge() {
    switch (project.status) {
      case ProjectStatus.underConstruction:
      case ProjectStatus.active:
        return StatusBadge.success(project.status.displayName, showDot: true);
      case ProjectStatus.completed:
      case ProjectStatus.ready:
        return StatusBadge.info(project.status.displayName, showDot: true);
      case ProjectStatus.presale:
        return StatusBadge.warning(project.status.displayName, showDot: true);
      case ProjectStatus.suspended:
        return StatusBadge.neutral(project.status.displayName, showDot: true);
    }
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.name,
          style: AppTextStyles.h4,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            SvgPicture.string(
              AppIcons.mapPin,
              width: AppSizes.iconS.w,
              colorFilter: const ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                project.location,
                style: AppTextStyles.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              label: 'projects_units_total'.tr(),
              value: project.totalUnits.toString(),
            ),
          ),
          Container(
            width: 1,
            height: 32.h,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              label: 'projects_units_empty'.tr(),
              value: project.availableUnits.toString(),
              valueColor: AppColors.success,
            ),
          ),
          Container(
            width: 1,
            height: 32.h,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              label: 'projects_completion_year'.tr(),
              value: project.completionYear,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.overline,
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    final percentage = project.soldPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${percentage.toStringAsFixed(0)}% sotilgan',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Row(
              children: [
                Text(
                  'projects_detail_action'.tr(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                SvgPicture.string(
                  AppIcons.chevronRight,
                  width: AppSizes.iconS.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppSizes.p8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage >= 80
                  ? AppColors.success
                  : percentage >= 50
                      ? AppColors.primary
                      : AppColors.warning,
            ),
            minHeight: 8.h,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for pattern overlay on project card header.
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(13)
      ..style = PaintingStyle.fill;

    // Draw subtle circles pattern
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.2), size.height * 0.5),
        size.height * 0.3,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
