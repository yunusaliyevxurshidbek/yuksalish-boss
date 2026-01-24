import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/analytics_theme.dart';

/// Data model for inventory segment bar
class InventorySegmentData {
  final int available;
  final int sold;
  final int reserved;

  const InventorySegmentData({
    required this.available,
    required this.sold,
    required this.reserved,
  });

  int get total => available + sold + reserved;

  double get availablePercent => total > 0 ? available / total : 0;
  double get soldPercent => total > 0 ? sold / total : 0;
  double get reservedPercent => total > 0 ? reserved / total : 0;

  /// Create from inventory bar data list (aggregates all projects)
  factory InventorySegmentData.aggregate(List<dynamic> inventoryData) {
    int totalAvailable = 0;
    int totalSold = 0;
    int totalReserved = 0;

    for (final item in inventoryData) {
      totalAvailable += (item.available as int?) ?? 0;
      totalSold += (item.sold as int?) ?? 0;
      totalReserved += (item.reserved as int?) ?? 0;
    }

    return InventorySegmentData(
      available: totalAvailable,
      sold: totalSold,
      reserved: totalReserved,
    );
  }
}

/// Premium segmented horizontal progress bar (battery-style)
/// Shows [Available | Sold | Reserved] as colored segments
class InventorySegmentBar extends StatefulWidget {
  final InventorySegmentData data;
  final double height;
  final bool showLabels;
  final bool showLegend;
  final bool showCounts;

  const InventorySegmentBar({
    super.key,
    required this.data,
    this.height = 36,
    this.showLabels = true,
    this.showLegend = true,
    this.showCounts = true,
  });

  @override
  State<InventorySegmentBar> createState() => _InventorySegmentBarState();
}

class _InventorySegmentBarState extends State<InventorySegmentBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    if (widget.data.total == 0) {
      return _buildEmptyState(colors);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary stats row
            if (widget.showCounts) ...[
              _buildSummaryRow(colors),
              SizedBox(height: AppSizes.p12.h),
            ],
            // Segmented bar
            _buildSegmentedBar(colors),
            // Legend
            if (widget.showLegend) ...[
              SizedBox(height: AppSizes.p16.h),
              _buildLegend(colors),
            ],
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(AnalyticsPremiumColors colors) {
    return Container(
      height: widget.height.h,
      decoration: BoxDecoration(
        color: colors.cardBorder,
        borderRadius: BorderRadius.circular(AnalyticsRadius.progressBar.r),
      ),
      child: Center(
        child: Text(
          'analytics_no_inventory_data'.tr(),
          style: AppTextStyles.caption.copyWith(
            color: colors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(AnalyticsPremiumColors colors) {
    return Row(
      children: [
        Text(
          '${'analytics_total_label'.tr()}: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.textSubtitle,
          ),
        ),
        Text(
          '${widget.data.total}',
          style: AppTextStyles.labelLarge.copyWith(
            color: colors.textHeading,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          ' ${'analytics_apartments_count'.tr()}',
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.textSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedBar(AnalyticsPremiumColors colors) {
    return Container(
      height: widget.height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AnalyticsRadius.progressBar.r),
        boxShadow: [colors.innerShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AnalyticsRadius.progressBar.r),
        child: Row(
          children: [
            // Available segment (green)
            _buildSegment(
              flex: (widget.data.availablePercent * 100 * _animation.value)
                  .round(),
              color: colors.available,
              label: widget.showLabels && widget.data.availablePercent >= 0.12
                  ? '${(widget.data.availablePercent * 100).toInt()}%'
                  : null,
            ),
            // Sold segment (blue)
            _buildSegment(
              flex:
                  (widget.data.soldPercent * 100 * _animation.value).round(),
              color: colors.sold,
              label: widget.showLabels && widget.data.soldPercent >= 0.12
                  ? '${(widget.data.soldPercent * 100).toInt()}%'
                  : null,
            ),
            // Reserved segment (orange)
            _buildSegment(
              flex: (widget.data.reservedPercent * 100 * _animation.value)
                  .round(),
              color: colors.reserved,
              label: widget.showLabels && widget.data.reservedPercent >= 0.12
                  ? '${(widget.data.reservedPercent * 100).toInt()}%'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment({
    required int flex,
    required Color color,
    String? label,
  }) {
    if (flex <= 0) return const SizedBox.shrink();

    return Flexible(
      flex: flex,
      child: Container(
        height: double.infinity,
        color: color,
        child: label != null
            ? Center(
                child: Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildLegend(AnalyticsPremiumColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(
          'analytics_available_short'.tr(),
          colors.available,
          widget.data.available,
          (widget.data.availablePercent * 100).toInt(),
        ),
        SizedBox(width: 20.w),
        _legendItem(
          'analytics_sold'.tr(),
          colors.sold,
          widget.data.sold,
          (widget.data.soldPercent * 100).toInt(),
        ),
        SizedBox(width: 20.w),
        _legendItem(
          'analytics_reserved_short'.tr(),
          colors.reserved,
          widget.data.reserved,
          (widget.data.reservedPercent * 100).toInt(),
        ),
      ],
    );
  }

  Widget _legendItem(String label, Color color, int count, int percentage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          '$label: $count',
          style: AppTextStyles.caption.copyWith(
            color: AnalyticsPremiumColors.of(context).textSubtitle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '($percentage%)',
          style: AppTextStyles.caption.copyWith(
            color: AnalyticsPremiumColors.of(context).textMuted,
          ),
        ),
      ],
    );
  }
}

/// Compact version for inline use
class InventorySegmentBarCompact extends StatelessWidget {
  final InventorySegmentData data;
  final double height;

  const InventorySegmentBarCompact({
    super.key,
    required this.data,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AnalyticsPremiumColors.of(context);
    if (data.total == 0) {
      return Container(
        height: height.h,
        decoration: BoxDecoration(
          color: colors.cardBorder,
          borderRadius: BorderRadius.circular(height.r / 2),
        ),
      );
    }

    return Container(
      height: height.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height.r / 2),
      ),
      child: Row(
        children: [
          if (data.available > 0)
            Expanded(
              flex: (data.availablePercent * 100).round(),
              child: Container(color: colors.available),
            ),
          if (data.sold > 0)
            Expanded(
              flex: (data.soldPercent * 100).round(),
              child: Container(color: colors.sold),
            ),
          if (data.reserved > 0)
            Expanded(
              flex: (data.reservedPercent * 100).round(),
              child: Container(color: colors.reserved),
            ),
        ],
      ),
    );
  }
}
