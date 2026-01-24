import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/funnel_models.dart';
import 'funnel_donut_chart.dart';

/// Card containing the funnel donut chart.
class FunnelChartCard extends StatelessWidget {
  final List<FunnelStage> stages;

  const FunnelChartCard({super.key, required this.stages});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: FunnelDonutChart(stages: stages),
    );
  }
}
