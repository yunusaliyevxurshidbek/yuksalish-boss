import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';
import '../utils/analytics_utils.dart';

class RevenueBreakdownBar extends StatelessWidget {
  final double paidAmount;
  final double pendingAmount;
  final double availableAmount;

  const RevenueBreakdownBar({
    super.key,
    required this.paidAmount,
    required this.pendingAmount,
    required this.availableAmount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    final total = paidAmount + pendingAmount + availableAmount;
    if (total <= 0) {
      return Container(
        height: 24.h,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: colors.cardBorder,
          borderRadius: BorderRadius.circular(12.r),
        ),
      );
    }

    final paidPercent = (paidAmount / total) * 100;
    final pendingPercent = (pendingAmount / total) * 100;
    final availablePercent = (availableAmount / total) * 100;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Row(
            children: [
              _buildSegment(
                width: width * (paidPercent / 100),
                color: colors.success,
                label: paidPercent >= 10 ? formatCurrency(paidAmount) : null,
              ),
              _buildSegment(
                width: width * (pendingPercent / 100),
                color: colors.warning,
                label: pendingPercent >= 10 ? formatCurrency(pendingAmount) : null,
              ),
              _buildSegment(
                width: width * (availablePercent / 100),
                color: colors.available,
                label: availablePercent >= 10 ? formatCurrency(availableAmount) : null,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSegment({
    required double width,
    required Color color,
    String? label,
  }) {
    if (width <= 0) {
      return const SizedBox.shrink();
    }
    return Container(
      width: width,
      height: 24.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color),
      child: label == null
          ? null
          : Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
