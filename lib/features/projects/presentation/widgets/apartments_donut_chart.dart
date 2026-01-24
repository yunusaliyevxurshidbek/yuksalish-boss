import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/project.dart';

/// Donut chart showing apartment status distribution.
class ApartmentsDonutChart extends StatelessWidget {
  final Project project;
  final double size;

  const ApartmentsDonutChart({
    super.key,
    required this.project,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kvartiralar holati',
            style: AppTextStyles.labelLarge.copyWith(
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            children: [
              SizedBox(
                width: size.w,
                height: size.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(size.w, size.w),
                      painter: _DonutChartPainter(
                        available: project.availableUnits,
                        sold: project.soldUnits,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'projects_units_total'.tr(),
                          style: AppTextStyles.caption.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        Text(
                          project.totalUnits.toString(),
                          style: AppTextStyles.h2.copyWith(
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSizes.p24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      context: context,
                      color: AppColors.success,
                      label: 'projects_units_empty'.tr(),
                      count: project.availableUnits,
                      percentage: _calculatePercentage(project.availableUnits),
                    ),
                    SizedBox(height: AppSizes.p12.h),
                    _buildLegendItem(
                      context: context,
                      color: AppColors.primary,
                      label: 'projects_units_sold'.tr(),
                      count: project.soldUnits,
                      percentage: _calculatePercentage(project.soldUnits),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculatePercentage(int count) {
    if (project.totalUnits == 0) return 0;
    return ((count / project.totalUnits) * 100).round();
  }

  Widget _buildLegendItem({
    required BuildContext context,
    required Color color,
    required String label,
    required int count,
    required int percentage,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: AppSizes.p8.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        Text(
          '$count',
          style: AppTextStyles.labelMedium.copyWith(
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '($percentage%)',
          style: AppTextStyles.caption.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for donut chart.
class _DonutChartPainter extends CustomPainter {
  final int available;
  final int sold;

  _DonutChartPainter({
    required this.available,
    required this.sold,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.35;

    final total = available + sold;
    if (total == 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final segments = [
      _ChartSegment(available / total, AppColors.success),
      _ChartSegment(sold / total, AppColors.primary),
    ];

    double startAngle = -math.pi / 2; // Start from top
    const gapAngle = 0.03; // Small gap between segments

    for (final segment in segments) {
      if (segment.fraction > 0) {
        final sweepAngle = segment.fraction * 2 * math.pi - gapAngle;

        paint.color = segment.color;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
          startAngle,
          sweepAngle,
          false,
          paint,
        );

        startAngle += segment.fraction * 2 * math.pi;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.available != available || oldDelegate.sold != sold;
  }
}

class _ChartSegment {
  final double fraction;
  final Color color;

  _ChartSegment(this.fraction, this.color);
}
