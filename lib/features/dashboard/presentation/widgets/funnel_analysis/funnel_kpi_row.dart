import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/funnel_models.dart';

/// Row of KPI metric cards.
class FunnelKpiRow extends StatelessWidget {
  final List<FunnelKpi> kpis;

  const FunnelKpiRow({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Row(
      children: List.generate(kpis.length, (index) {
        final kpi = kpis[index];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == kpis.length - 1 ? 0 : 10.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kpi.label.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  kpi.value,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: kpi.valueColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
