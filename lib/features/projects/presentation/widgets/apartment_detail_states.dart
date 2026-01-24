import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';

class ApartmentDetailLoadingState extends StatelessWidget {
  final Widget backButton;

  const ApartmentDetailLoadingState({super.key, required this.backButton});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerColor = isDark ? AppColors.darkBorder : AppColors.border;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280.h,
          pinned: true,
          backgroundColor: theme.cardColor,
          surfaceTintColor: Colors.transparent,
          leading: backButton,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: shimmerColor.withAlpha(100),
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skeleton header
                Container(
                  height: 28.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: shimmerColor.withAlpha(100),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 24.h),
                // Skeleton card
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                    color: shimmerColor.withAlpha(80),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                SizedBox(height: 16.h),
                // Skeleton price card
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ApartmentDetailErrorState extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const ApartmentDetailErrorState({
    super.key,
    this.error,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Xatolik yuz berdi',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error ?? 'Ma\'lumotlarni yuklashda xatolik',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: Text('common_back'.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.textTheme.bodySmall?.color,
                    side: BorderSide(color: borderColor),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text('common_retry'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ApartmentDetailEmptyState extends StatelessWidget {
  final VoidCallback onBack;

  const ApartmentDetailEmptyState({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 64.w,
            color: theme.textTheme.bodySmall?.color,
          ),
          SizedBox(height: 16.h),
          Text(
            'Kvartira topilmadi',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: 24.h),
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text('common_back'.tr()),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
