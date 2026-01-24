import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';
import '../utils/analytics_utils.dart';
import 'analytics_chart_card.dart';
import 'payments_bar_chart.dart';

class AnalyticsPaymentsSection extends StatelessWidget {
  final List<PaymentsChartData> data;
  final double totalAmount;
  final int totalCount;
  final DateTime from;
  final DateTime to;
  final ValueChanged<DateTime> onFromChanged;
  final ValueChanged<DateTime> onToChanged;

  const AnalyticsPaymentsSection({
    super.key,
    required this.data,
    required this.totalAmount,
    required this.totalCount,
    required this.from,
    required this.to,
    required this.onFromChanged,
    required this.onToChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return AnalyticsChartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'analytics_payments_count'.tr(namedArgs: {'count': '$totalCount'})} • ${formatCurrency(totalAmount)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: colors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.p12.h),
          AnalyticsDateRangeRow(
            from: from,
            to: to,
            onFromChanged: onFromChanged,
            onToChanged: onToChanged,
          ),
          SizedBox(height: AppSizes.p16.h),
          PaymentsBarChart(data: data),
        ],
      ),
    );
  }
}

class AnalyticsDateRangeRow extends StatelessWidget {
  final DateTime from;
  final DateTime to;
  final ValueChanged<DateTime> onFromChanged;
  final ValueChanged<DateTime> onToChanged;

  const AnalyticsDateRangeRow({
    super.key,
    required this.from,
    required this.to,
    required this.onFromChanged,
    required this.onToChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.p12.w,
      runSpacing: AppSizes.p8.h,
      children: [
        AnalyticsDateField(
          label: 'analytics_date_from'.tr(),
          value: from,
          onTap: () async {
            final picked = await _pickDate(context, from);
            if (picked != null) onFromChanged(picked);
          },
        ),
        AnalyticsDateField(
          label: 'analytics_date_to'.tr(),
          value: to,
          onTap: () async {
            final picked = await _pickDate(context, to);
            if (picked != null) onToChanged(picked);
          },
        ),
      ],
    );
  }

  Future<DateTime?> _pickDate(BuildContext context, DateTime initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(initialDate.year - 5),
      lastDate: DateTime(initialDate.year + 1),
    );
  }
}

class AnalyticsDateField extends StatelessWidget {
  final String label;
  final DateTime value;
  final VoidCallback onTap;

  const AnalyticsDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p12.w,
          vertical: AppSizes.p8.h,
        ),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14.w,
              color: colors.primary,
            ),
            SizedBox(width: AppSizes.p8.w),
            Text(
              '$label: ${_formatDate(value)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.textHeading,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
