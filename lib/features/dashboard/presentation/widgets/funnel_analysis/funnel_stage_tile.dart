import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/funnel_models.dart';
import 'funnel_progress_bar.dart';

/// Tile for a funnel stage.
class FunnelStageTile extends StatelessWidget {
  final FunnelStage stage;
  final int total;

  const FunnelStageTile({
    super.key,
    required this.stage,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final percent = total == 0
        ? 0
        : (stage.count / total * 100).round();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: stage.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  stage.name,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
              ),
              Text(
                'dashboard_funnel_stage_count'.tr(namedArgs: {'count': '${stage.count}', 'percent': '$percent'}),
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          FunnelProgressBar(
            color: stage.color,
            value: percent / 100,
          ),
        ],
      ),
    );
  }
}
