import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/project.dart';

class ProjectCarouselCard extends StatelessWidget {
  final Project project;
  final bool isSelected;
  final VoidCallback? onTap;

  const ProjectCarouselCard({
    super.key,
    required this.project,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 3.w)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isSelected ? 30 : 15),
              blurRadius: isSelected ? 12 : 8,
              offset: Offset(0, isSelected ? 6 : 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 13.r : 16.r),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: _buildBackgroundImage(),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(180),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
              ),
              // Content
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      _buildStatusBadge(),
                      const Spacer(),
                      // Project name
                      Text(
                        project.name,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.w,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              project.location,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      // Divider
                      Container(
                        height: 1,
                        color: Colors.white24,
                      ),
                      SizedBox(height: 10.h),
                      // Stats row
                      _buildStatsRow(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    if (project.image != null && project.image!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: project.image!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.primary.withAlpha(50),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary.withAlpha(100),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderImage(),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withAlpha(150),
            AppColors.primary.withAlpha(200),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.apartment_rounded,
          size: 48.w,
          color: Colors.white.withAlpha(100),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getStatusColor().withAlpha(230),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        project.status.badgeLabel,
        style: GoogleFonts.inter(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (project.status) {
      case ProjectStatus.underConstruction:
        return const Color(0xFFF39C12);
      case ProjectStatus.ready:
      case ProjectStatus.active:
      case ProjectStatus.completed:
        return const Color(0xFF27AE60);
      case ProjectStatus.presale:
        return const Color(0xFF3498DB);
      case ProjectStatus.suspended:
        return const Color(0xFF95A5A6);
    }
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('projects_units_total'.tr(), '${project.totalUnits}'),
        _buildStatItem('projects_units_empty'.tr(), '${project.availableUnits}',
            valueColor: const Color(0xFF27AE60)),
        _buildStatItem('projects_completion_year'.tr(), project.completionYear),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white54,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
