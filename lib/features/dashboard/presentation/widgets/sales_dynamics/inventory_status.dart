import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_colors.dart';
import 'summary_cards.dart';

/// Apartments inventory status section (from builder stats)
class InventoryStatusSection extends StatelessWidget {
  final int totalUnits;
  final int availableUnits;
  final int reservedUnits;
  final int soldUnits;
  final double soldValue;

  const InventoryStatusSection({
    super.key,
    required this.totalUnits,
    required this.availableUnits,
    required this.reservedUnits,
    required this.soldUnits,
    required this.soldValue,
  });

  double get availablePercent =>
      totalUnits > 0 ? (availableUnits / totalUnits * 100) : 0;
  double get reservedPercent =>
      totalUnits > 0 ? (reservedUnits / totalUnits * 100) : 0;
  double get soldPercent => totalUnits > 0 ? (soldUnits / totalUnits * 100) : 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dashboard_inventory_status'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 12.h),
          // Summary row
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dashboard_inventory_total'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'dashboard_inventory_total_apartments'.tr(namedArgs: {'count': '$totalUnits'}),
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.textTheme.titleLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 36.h,
                  color: borderColor,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dashboard_inventory_sold_value'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        CurrencyFormatter.format(soldValue),
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.salesSuccess,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 12.h,
              child: Row(
                children: [
                  if (availablePercent > 0)
                    Expanded(
                      flex: availablePercent.round(),
                      child: Container(color: AppColors.salesSuccess),
                    ),
                  if (reservedPercent > 0)
                    Expanded(
                      flex: reservedPercent.round(),
                      child: Container(color: AppColors.salesWarning),
                    ),
                  if (soldPercent > 0)
                    Expanded(
                      flex: soldPercent.round(),
                      child: Container(color: theme.colorScheme.primary),
                    ),
                  if (totalUnits == 0)
                    Expanded(
                      child: Container(color: borderColor),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Legend
          Row(
            children: [
              Expanded(
                child: _InventoryItem(
                  color: AppColors.salesSuccess,
                  label: 'dashboard_inventory_available'.tr(),
                  count: availableUnits,
                  percent: availablePercent,
                  theme: theme,
                ),
              ),
              Expanded(
                child: _InventoryItem(
                  color: AppColors.salesWarning,
                  label: 'dashboard_inventory_reserved'.tr(),
                  count: reservedUnits,
                  percent: reservedPercent,
                  theme: theme,
                ),
              ),
              Expanded(
                child: _InventoryItem(
                  color: theme.colorScheme.primary,
                  label: 'dashboard_inventory_sold'.tr(),
                  count: soldUnits,
                  percent: soldPercent,
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventoryItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final double percent;
  final ThemeData theme;

  const _InventoryItem({
    required this.color,
    required this.label,
    required this.count,
    required this.percent,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Text(
            '$count (${percent.toStringAsFixed(0)}%)',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}
