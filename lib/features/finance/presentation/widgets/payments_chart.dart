import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/payment_stats.dart';

/// Donut chart showing payment status distribution
class PaymentsChart extends StatefulWidget {
  const PaymentsChart({
    super.key,
    required this.stats,
  });

  final PaymentStats stats;

  @override
  State<PaymentsChart> createState() => _PaymentsChartState();
}

class _PaymentsChartState extends State<PaymentsChart>
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(AppSizes.p16.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(
              color: borderColor,
              width: AppSizes.borderThin,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'finance_payment_chart_title'.tr(),
                style: AppTextStyles.h4.copyWith(
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              SizedBox(height: AppSizes.p16.h),
              Row(
                children: [
                  // Donut chart
                  SizedBox(
                    width: 140.w,
                    height: 140.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (event, response) {
                                setState(() {
                                  if (response == null ||
                                      response.touchedSection == null) {
                                    _touchedIndex = null;
                                  } else {
                                    _touchedIndex = response
                                        .touchedSection!.touchedSectionIndex;
                                  }
                                });
                              },
                            ),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40.r,
                            sections: _buildSections(),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(widget.stats.paidPercentage * _animation.value).toInt()}%',
                              style: AppTextStyles.h3.copyWith(
                                color: theme.textTheme.titleMedium?.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'finance_paid'.tr(),
                              style: AppTextStyles.caption.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSizes.p24.w),
                  // Legend
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(
                          context,
                          'finance_paid'.tr(),
                          '${widget.stats.paidPercentage.toInt()}%',
                          AppColors.chartGreen,
                          _touchedIndex == 0,
                        ),
                        SizedBox(height: AppSizes.p12.h),
                        _buildLegendItem(
                          context,
                          'finance_pending'.tr(),
                          '${widget.stats.pendingPercentage.toInt()}%',
                          AppColors.chartYellow,
                          _touchedIndex == 1,
                        ),
                        SizedBox(height: AppSizes.p12.h),
                        _buildLegendItem(
                          context,
                          'finance_overdue_initial_payments'.tr(),
                          '${widget.stats.noInitialPercentage.toInt()}%',
                          AppColors.chartRed,
                          _touchedIndex == 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections() {
    final values = [
      widget.stats.paidPercentage,
      widget.stats.pendingPercentage,
      widget.stats.noInitialPercentage,
    ];
    final colors = [
      AppColors.chartGreen,
      AppColors.chartYellow,
      AppColors.chartRed,
    ];

    return List.generate(values.length, (index) {
      final isTouched = _touchedIndex == index;
      final radius = isTouched ? 28.r : 24.r;

      return PieChartSectionData(
        color: colors[index],
        value: values[index] * _animation.value,
        radius: radius,
        showTitle: false,
      );
    });
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    bool isHighlighted,
  ) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p8.w,
        vertical: AppSizes.p4.h,
      ),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppSizes.p8.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
                fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
