import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/lead_source.dart';
import '../theme/analytics_theme.dart';
import 'analytics_empty_state.dart';

/// Premium donut chart showing lead sources distribution
/// Features thicker donut, circular legend bullets, and animated center text
class LeadSourcesChart extends StatefulWidget {
  const LeadSourcesChart({
    super.key,
    required this.data,
    this.height = 280,
    this.centerLabel,
  });

  final List<LeadSource> data;
  final double height;
  final String? centerLabel;

  @override
  State<LeadSourcesChart> createState() => _LeadSourcesChartState();
}

class _LeadSourcesChartState extends State<LeadSourcesChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int get _totalCount =>
      widget.data.fold<int>(0, (sum, source) => sum + source.count);

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.height.h,
        child: AnalyticsEmptyStateCompact(
          message: 'analytics_lead_sources_no_data'.tr(),
          icon: Icons.pie_chart_outline_rounded,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: widget.height.h,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: _buildDonutChart(colors),
              ),
              SizedBox(height: AppSizes.p16.h),
              _buildLegend(colors),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDonutChart(AnalyticsPremiumColors colors) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 3,
            centerSpaceRadius: 55.r,
            sections: _buildSections(),
            pieTouchData: PieTouchData(
              touchCallback: (event, response) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.touchedSection == null) {
                    _touchedIndex = null;
                    return;
                  }
                  _touchedIndex = response.touchedSection!.touchedSectionIndex;
                });
              },
            ),
          ),
        ),
        // Center text with animated count
        Builder(
          builder: (context) {
            final label = widget.centerLabel ?? 'analytics_total_leads'.tr();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(_totalCount * _animation.value).toInt()}',
                  style: AppTextStyles.metricLarge.copyWith(
                    color: colors.textHeading,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textSubtitle,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final source = entry.value;
      final isTouched = _touchedIndex == index;
      final radius = isTouched ? 40.r : 35.r;

      return PieChartSectionData(
        color: source.color,
        value: source.percentage * _animation.value,
        title: isTouched ? '${source.percentage.toStringAsFixed(0)}%' : '',
        radius: radius,
        titleStyle: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 0.55,
      );
    }).toList();
  }

  Widget _buildLegend(AnalyticsPremiumColors colors) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.p16.w,
      runSpacing: AppSizes.p8.h,
      children: widget.data.asMap().entries.map((entry) {
        final index = entry.key;
        final source = entry.value;
        final isTouched = _touchedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _touchedIndex = _touchedIndex == index ? null : index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: isTouched
                  ? source.color.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AnalyticsRadius.small.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular bullet
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: source.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSizes.p8.w),
                Text(
                  source.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isTouched
                        ? colors.textHeading
                        : colors.textSubtitle,
                    fontWeight: isTouched ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '(${source.count})',
                  style: AppTextStyles.caption.copyWith(
                    color: isTouched
                        ? colors.textHeading
                        : colors.textMuted,
                    fontWeight: isTouched ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
