import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/analytics_project.dart';
import '../theme/analytics_theme.dart';
import '../utils/analytics_utils.dart';
import 'analytics_chart_card.dart';
import 'revenue_breakdown_bar.dart';

class AnalyticsRevenueBreakdownSection extends StatelessWidget {
  final List<AnalyticsProject> projects;
  final String selectedProjectId;
  final ValueChanged<String> onProjectChanged;
  final double paidAmount;
  final double pendingAmount;
  final double availableAmount;

  const AnalyticsRevenueBreakdownSection({
    super.key,
    required this.projects,
    required this.selectedProjectId,
    required this.onProjectChanged,
    required this.paidAmount,
    required this.pendingAmount,
    required this.availableAmount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    final total = paidAmount + pendingAmount + availableAmount;

    return AnalyticsChartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'analytics_project'.tr(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnalyticsProjectSelector(
                    projects: projects,
                    selectedProjectId: selectedProjectId,
                    onChanged: onProjectChanged,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p12.h),
          Text(
            '${'analytics_total'.tr()}: ${formatCurrency(total)}',
            style: AppTextStyles.bodyLarge.copyWith(
              color: colors.textHeading,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSizes.p12.h),
          RevenueBreakdownBar(
            paidAmount: paidAmount,
            pendingAmount: pendingAmount,
            availableAmount: availableAmount,
          ),
          SizedBox(height: AppSizes.p12.h),
          Wrap(
            spacing: AppSizes.p16.w,
            runSpacing: AppSizes.p8.h,
            children: [
              AnalyticsLegendItem(
                label: 'analytics_payments'.tr(),
                value: _percentage(paidAmount, total),
                color: colors.success,
              ),
              AnalyticsLegendItem(
                label: 'analytics_pending_payments'.tr(),
                value: _percentage(pendingAmount, total),
                color: colors.warning,
              ),
              AnalyticsLegendItem(
                label: 'analytics_available_apartments'.tr(),
                value: _percentage(availableAmount, total),
                color: colors.available,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _percentage(double amount, double total) {
    if (total <= 0) return '0%';
    return '${((amount / total) * 100).toStringAsFixed(0)}%';
  }
}

class AnalyticsProjectSelector extends StatelessWidget {
  final List<AnalyticsProject> projects;
  final String selectedProjectId;
  final ValueChanged<String> onChanged;

  const AnalyticsProjectSelector({
    super.key,
    required this.projects,
    required this.selectedProjectId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p8.w,
          vertical: AppSizes.p4.h,
        ),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(color: colors.cardBorder),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedProjectId,
            isDense: true,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colors.textMuted,
            ),
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
            items: [
              DropdownMenuItem(
                value: 'all',
                child: Text(
                  'analytics_all_objects'.tr(),
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textHeading,
                  ),
                ),
              ),
              ...projects.map(
                (project) => DropdownMenuItem(
                  value: project.id.toString(),
                  child: Text(
                    project.name,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textHeading,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnalyticsLegendItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const AnalyticsLegendItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          '$label ($value)',
          style: AppTextStyles.caption.copyWith(
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }
}
