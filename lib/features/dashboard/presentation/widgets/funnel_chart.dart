import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:yuksalish_mobile/core/constants/app_sizes.dart';
import 'package:yuksalish_mobile/core/constants/app_text_styles.dart';
import 'package:yuksalish_mobile/core/constants/app_colors.dart';
import 'package:yuksalish_mobile/core/widgets/widgets.dart';
import 'package:yuksalish_mobile/features/dashboard/data/models/funnel_data.dart';

class FunnelChart extends StatefulWidget {
  final List<FunnelData> data;
  final bool isLoading;
  final VoidCallback? onSeeAllTap;

  const FunnelChart({
    super.key,
    required this.data,
    this.isLoading = false,
    this.onSeeAllTap,
  });

  @override
  State<FunnelChart> createState() => _FunnelChartState();
}

class _FunnelChartState extends State<FunnelChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
      widget.data.fold<int>(0, (sum, item) => sum + item.count);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'dashboard_funnel_title'.tr(),
            actionText: 'dashboard_see_all'.tr(),
            onActionTap: widget.onSeeAllTap,
          ),
          SizedBox(height: AppSizes.p16.h),
          Container(
            padding: EdgeInsets.all(AppSizes.p16.w),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
                width: AppSizes.borderThin,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: widget.isLoading
                ? const _ChartShimmer()
                : AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) => _buildContent(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final theme = Theme.of(context);

    if (widget.data.isEmpty) {
      return SizedBox(
        height: 180.h,
        child: Center(
          child: Text(
            'dashboard_no_data'.tr(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 180.h,
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
                            _touchedIndex = response
                                .touchedSection!.touchedSectionIndex;
                          }
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 50.r,
                    sections: _buildSections(),
                    startDegreeOffset: -90,
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 300),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_totalCount',
                      style: AppTextStyles.h2.copyWith(
                        color: theme.textTheme.headlineMedium?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'dashboard_funnel_total'.tr(),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: AppSizes.p16.w),
        Expanded(
          flex: 4,
          child: _buildLegend(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = _touchedIndex == index;
      final percentage = _totalCount > 0
          ? (data.count / _totalCount * 100 * _animation.value)
          : 0.0;

      return PieChartSectionData(
        color: data.color,
        value: data.count.toDouble() * _animation.value,
        title: isTouched ? '${percentage.toStringAsFixed(0)}%' : '',
        radius: isTouched ? 35.r : 30.r,
        titleStyle: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11.sp,
        ),
        titlePositionPercentageOffset: 0.55,
      );
    }).toList();
  }

  Widget _buildLegend() {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.data.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final isTouched = _touchedIndex == index;

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _touchedIndex = _touchedIndex == index ? null : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: isTouched
                    ? data.color.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: data.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      data.stage,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isTouched
                            ? theme.textTheme.bodyLarge?.color
                            : theme.textTheme.bodySmall?.color,
                        fontWeight:
                            isTouched ? FontWeight.w600 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${data.count}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isTouched
                          ? data.color
                          : theme.textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ChartShimmer extends StatelessWidget {
  const _ChartShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: AppShimmer(
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 30.w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.p16.w),
          Expanded(
            flex: 4,
            child: AppShimmer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Container(
                            height: 12.h,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 24.w,
                          height: 12.h,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
