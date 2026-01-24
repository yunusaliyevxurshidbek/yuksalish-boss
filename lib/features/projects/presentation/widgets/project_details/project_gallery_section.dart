import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'project_details_colors.dart';

/// Horizontal scrollable gallery section showing construction progress images.
class ProjectGallerySection extends StatelessWidget {
  final List<String> images;
  final VoidCallback? onSeeAllTap;
  final ValueChanged<int>? onImageTap;

  const ProjectGallerySection({
    super.key,
    required this.images,
    this.onSeeAllTap,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'projects_gallery_title'.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: ProjectDetailsColors.textDark,
                  fontFamily: 'Inter',
                ),
              ),
              TextButton(
                onPressed: onSeeAllTap,
                child: Text(
                  'projects_gallery_see_all'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ProjectDetailsColors.primaryBlue,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: images.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => _GalleryItem(
              imageUrl: images[index],
              onTap: () => onImageTap?.call(index),
            ),
          ),
        ),
      ],
    );
  }
}

class _GalleryItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const _GalleryItem({
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ProjectDetailsColors.divider,
                    child: Icon(
                      Icons.image_outlined,
                      size: 40.w,
                      color: ProjectDetailsColors.textTertiary,
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Yanvar 2025',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
