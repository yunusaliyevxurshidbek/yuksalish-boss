import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/funnel_models.dart';

/// Donut chart showing funnel stage distribution.
class FunnelDonutChart extends StatefulWidget {
  final List<FunnelStage> stages;

  const FunnelDonutChart({super.key, required this.stages});

  @override
  State<FunnelDonutChart> createState() => _FunnelDonutChartState();
}

class _FunnelDonutChartState extends State<FunnelDonutChart> {
  int? _touchedIndex;

  int get _total =>
      widget.stages.fold<int>(0, (sum, stage) => sum + stage.count);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 280.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      _touchedIndex = null;
                    } else {
                      _touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    }
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 3.w,
              centerSpaceRadius: 64.r,
              startDegreeOffset: -90,
              sections: _buildSections(theme),
            ),
            swapAnimationDuration: const Duration(milliseconds: 320),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _total.toString(),
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'dashboard_funnel_total'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(ThemeData theme) {
    return widget.stages.asMap().entries.map((entry) {
      final index = entry.key;
      final stage = entry.value;
      final isTouched = _touchedIndex == index;
      final radius = isTouched ? 60.r : 54.r;
      final percentage =
          _total == 0 ? 0 : (stage.count / _total * 100).round();

      return PieChartSectionData(
        color: stage.color,
        value: stage.count.toDouble(),
        radius: radius,
        title: isTouched ? '$percentage%' : '',
        titleStyle: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: theme.cardColor,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }
}
