import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'project_details_colors.dart';

/// Sliver app bar for project details screen with glassmorphic action buttons.
class ProjectDetailsSliverAppBar extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onFavoriteToggle;

  const ProjectDetailsSliverAppBar({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.isFavorite,
    required this.onBack,
    required this.onShare,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280.h,
      floating: false,
      pinned: true,
      backgroundColor: ProjectDetailsColors.cardWhite,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: _GlassmorphicButton(
          icon: Icons.arrow_back_rounded,
          onTap: onBack,
        ),
      ),
      actions: [
        _GlassmorphicButton(
          icon: Icons.share_outlined,
          onTap: onShare,
        ),
        SizedBox(width: 8.w),
        _GlassmorphicButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          iconColor: isFavorite ? Colors.red : Colors.white,
          onTap: onFavoriteToggle,
        ),
        SizedBox(width: 8.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: ProjectDetailsColors.textDark,
          ),
        ),
        titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
        collapseMode: CollapseMode.pin,
        background: _buildBackground(),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: ProjectDetailsColors.primaryBlue.withValues(alpha: 0.3),
              child: Icon(
                Icons.apartment_rounded,
                size: 80.w,
                color: Colors.white54,
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Glassmorphic circular button for app bar actions.
class _GlassmorphicButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _GlassmorphicButton({
    required this.icon,
    this.iconColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: icon == Icons.arrow_back_rounded ? 24.w : 20.w,
            ),
          ),
        ),
      ),
    );
  }
}
