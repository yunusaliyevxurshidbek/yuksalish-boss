import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';

class InventoryDetailData {
  final int total;
  final int available;
  final int reserved;
  final int sold;
  final Map<int, int> roomBreakdown; // {1: 25, 2: 45, 3: 30}

  const InventoryDetailData({
    required this.total,
    required this.available,
    required this.reserved,
    required this.sold,
    required this.roomBreakdown,
  });
}

class InventoryDetailSection extends StatelessWidget {
  final InventoryDetailData data;

  const InventoryDetailSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [colors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary stats row
          _buildSummaryRow(colors),
          SizedBox(height: AppSizes.p16.h),
          // Progress bar
          _buildProgressBar(colors),
          SizedBox(height: AppSizes.p12.h),
          // Legend
          _buildLegend(colors),
          if (data.roomBreakdown.isNotEmpty) ...[
            SizedBox(height: AppSizes.p16.h),
            Divider(color: colors.cardBorder, height: 1),
            SizedBox(height: AppSizes.p16.h),
            // Room breakdown
            Text(
              'analytics_rooms_breakdown'.tr(),
              style: AppTextStyles.labelMedium.copyWith(
                color: colors.textMuted,
              ),
            ),
            SizedBox(height: AppSizes.p12.h),
            _buildRoomBreakdown(colors),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(AnalyticsPremiumColors colors) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'analytics_total_label'.tr(),
            value: data.total.toString(),
            color: colors.primary,
            textMuted: colors.textMuted,
          ),
        ),
        SizedBox(width: AppSizes.p8.w),
        Expanded(
          child: _StatCard(
            label: 'analytics_available'.tr(),
            value: data.available.toString(),
            percentage: _percentage(data.available),
            color: colors.success,
            textMuted: colors.textMuted,
          ),
        ),
        SizedBox(width: AppSizes.p8.w),
        Expanded(
          child: _StatCard(
            label: 'analytics_sold'.tr(),
            value: data.sold.toString(),
            percentage: _percentage(data.sold),
            color: colors.sold,
            textMuted: colors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(AnalyticsPremiumColors colors) {
    final total = data.total.toDouble();
    if (total <= 0) return const SizedBox.shrink();

    final availableWidth = data.available / total;
    final reservedWidth = data.reserved / total;
    final soldWidth = data.sold / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: SizedBox(
            height: 8.h,
            child: Row(
              children: [
                if (availableWidth > 0)
                  Flexible(
                    flex: (availableWidth * 100).round(),
                    child: Container(color: colors.success),
                  ),
                if (reservedWidth > 0)
                  Flexible(
                    flex: (reservedWidth * 100).round(),
                    child: Container(color: colors.warning),
                  ),
                if (soldWidth > 0)
                  Flexible(
                    flex: (soldWidth * 100).round(),
                    child: Container(color: colors.sold),
                  ),
              ],
            ),
          ),
        ),
        if (data.reserved > 0) ...[
          SizedBox(height: AppSizes.p8.h),
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: colors.warning,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'analytics_reserved_count'.tr(namedArgs: {'count': '${data.reserved}', 'percent': _percentage(data.reserved)}),
                style: AppTextStyles.caption.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLegend(AnalyticsPremiumColors colors) {
    return Wrap(
      spacing: AppSizes.p16.w,
      runSpacing: AppSizes.p8.h,
      children: [
        _legendItem('analytics_available'.tr(), colors.success, _percentage(data.available), colors),
        _legendItem('analytics_reserved_short'.tr(), colors.warning, _percentage(data.reserved), colors),
        _legendItem('analytics_sold'.tr(), colors.sold, _percentage(data.sold), colors),
      ],
    );
  }

  Widget _legendItem(
    String label,
    Color color,
    String percentage,
    AnalyticsPremiumColors colors,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          '$label ($percentage)',
          style: AppTextStyles.caption.copyWith(
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildRoomBreakdown(AnalyticsPremiumColors colors) {
    final sortedRooms = data.roomBreakdown.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Wrap(
      spacing: AppSizes.p8.w,
      runSpacing: AppSizes.p8.h,
      children: sortedRooms.map((entry) {
        return _RoomChip(
          rooms: entry.key,
          count: entry.value,
          colors: colors,
        );
      }).toList(),
    );
  }

  String _percentage(int value) {
    if (data.total <= 0) return '0%';
    return '${((value / data.total) * 100).toStringAsFixed(0)}%';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? percentage;
  final Color color;
  final Color textMuted;

  const _StatCard({
    required this.label,
    required this.value,
    this.percentage,
    required this.color,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12.w,
        vertical: AppSizes.p8.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: textMuted,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
              Text(
                value,
                style: AppTextStyles.h4.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (percentage != null) ...[
                SizedBox(width: 4.w),
                Text(
                  '($percentage)',
                  style: AppTextStyles.caption.copyWith(
                    color: textMuted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomChip extends StatelessWidget {
  final int rooms;
  final int count;
  final AnalyticsPremiumColors colors;

  const _RoomChip({
    required this.rooms,
    required this.count,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12.w,
        vertical: AppSizes.p8.h,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bed_rounded,
            size: 14.w,
            color: colors.primary,
          ),
          SizedBox(width: 4.w),
          Text(
            '${rooms}x: $count',
            style: AppTextStyles.labelSmall.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
