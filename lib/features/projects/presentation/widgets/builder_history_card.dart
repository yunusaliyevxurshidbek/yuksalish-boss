import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/builder_history_model.dart';

class BuilderHistoryCard extends StatelessWidget {
  final BuilderHistoryModel history;
  final VoidCallback? onTap;

  const BuilderHistoryCard({
    super.key,
    required this.history,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260.w,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor.withAlpha(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: history.image != null
                  ? CachedNetworkImage(
                      imageUrl: history.image!,
                      height: 100.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 100.h,
                        color: borderColor.withAlpha(100),
                        child: Center(
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary.withAlpha(150),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 100.h,
                        color: borderColor.withAlpha(100),
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 32.w,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    )
                  : Container(
                      height: 100.h,
                      color: borderColor.withAlpha(100),
                      child: Center(
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 32.w,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    history.title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.titleMedium?.color,
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
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          history.location,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Stats row
                  Row(
                    children: [
                      // Total units
                      _buildStatItem(
                        context: context,
                        icon: Icons.home_outlined,
                        value: '${history.totalUnits}',
                        label: 'projects_builder_unit'.tr(),
                      ),
                      SizedBox(width: 16.w),

                      // Sold duration
                      if (history.soldDuration != null)
                        _buildStatItem(
                          context: context,
                          icon: Icons.access_time_rounded,
                          value: history.soldDuration!,
                          label: '',
                        ),
                    ],
                  ),

                  // Completion info
                  if (history.actualCompletion != null) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF27AE60).withAlpha(20),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 12.w,
                            color: const Color(0xFF27AE60),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Tugallangan: ${_formatDate(history.actualCompletion!)}',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF27AE60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14.w,
          color: theme.textTheme.bodySmall?.color,
        ),
        SizedBox(width: 4.w),
        Text(
          label.isNotEmpty ? '$value $label' : value,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'yan',
        'fev',
        'mar',
        'apr',
        'may',
        'iyn',
        'iyl',
        'avg',
        'sen',
        'okt',
        'noy',
        'dek'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
