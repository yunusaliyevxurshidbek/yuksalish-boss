import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../data/models/models.dart';

/// Hero section for project detail screen with gradient background and pattern.
class ProjectDetailHeroSection extends StatelessWidget {
  final Project project;

  const ProjectDetailHeroSection({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(project.status),
        ),
      ),
      child: Stack(
        children: [
          // Pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _HeroPatternPainter(),
            ),
          ),
          // Content
          Positioned(
            left: AppSizes.p16.w,
            right: AppSizes.p16.w,
            bottom: 60.h, // Space for tab bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusBadge(project.status),
                SizedBox(height: AppSizes.p8.h),
                Text(
                  project.name,
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    SvgPicture.string(
                      AppIcons.mapPin,
                      width: AppSizes.iconS.w,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withAlpha(200),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        project.location,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withAlpha(200),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.underConstruction:
      case ProjectStatus.active:
        return [AppColors.primary, AppColors.primaryLight];
      case ProjectStatus.completed:
      case ProjectStatus.ready:
        return [AppColors.success, const Color(0xFF4ADE80)];
      case ProjectStatus.presale:
        return [AppColors.info, const Color(0xFF60A5FA)];
      case ProjectStatus.suspended:
        return [AppColors.textSecondary, const Color(0xFF94A3B8)];
    }
  }

  Widget _buildStatusBadge(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.underConstruction:
      case ProjectStatus.active:
        return StatusBadge.success(status.displayName, showDot: true);
      case ProjectStatus.completed:
      case ProjectStatus.ready:
        return StatusBadge.info(status.displayName, showDot: true);
      case ProjectStatus.presale:
        return StatusBadge.warning(status.displayName, showDot: true);
      case ProjectStatus.suspended:
        return StatusBadge.neutral(status.displayName, showDot: true);
    }
  }
}

/// Custom painter for hero section pattern.
class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(13)
      ..style = PaintingStyle.fill;

    // Draw subtle circles pattern
    for (int i = 0; i < 6; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.1 + i * 0.18), size.height * 0.3),
        size.height * 0.25,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
