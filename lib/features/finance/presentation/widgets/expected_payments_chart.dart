import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/payment_stats.dart';

/// Horizontal bar chart showing expected vs received payments
class ExpectedPaymentsChart extends StatefulWidget {
  const ExpectedPaymentsChart({
    super.key,
    required this.stats,
  });

  final PaymentStats stats;

  @override
  State<ExpectedPaymentsChart> createState() => _ExpectedPaymentsChartState();
}

class _ExpectedPaymentsChartState extends State<ExpectedPaymentsChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
    final total = widget.stats.totalReceived + widget.stats.pendingPayments;
    final receivedRatio = total > 0 ? widget.stats.totalReceived / total : 0.0;
    final expectedRatio = total > 0 ? widget.stats.pendingPayments / total : 0.0;

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
                'finance_expected_payments_title'.tr(),
                style: AppTextStyles.h4.copyWith(
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              SizedBox(height: AppSizes.p20.h),
              // Received bar
              _buildBar(
                context: context,
                label: 'finance_paid'.tr(),
                value: widget.stats.formattedTotalReceived,
                ratio: receivedRatio,
                color: AppColors.chartGreen,
              ),
              SizedBox(height: AppSizes.p16.h),
              // Expected bar
              _buildBar(
                context: context,
                label: 'finance_pending'.tr(),
                value: widget.stats.formattedPendingPayments,
                ratio: expectedRatio,
                color: AppColors.chartYellow,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBar({
    required BuildContext context,
    required String label,
    required String value,
    required double ratio,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            Text(
              '$value UZS',
              style: AppTextStyles.labelMedium.copyWith(
                color: theme.textTheme.titleMedium?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.p8.h),
        Container(
          height: 12.h,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * ratio * _animation.value,
                    height: 12.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
