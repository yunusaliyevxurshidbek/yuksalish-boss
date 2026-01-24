import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_colors.dart';

/// Contracts by status section
class ContractsStatusSection extends StatelessWidget {
  final Map<String, int> contractsByStatus;

  const ContractsStatusSection({super.key, required this.contractsByStatus});

  static Map<String, (String, Color)> get statusConfig => {
    'active': ('dashboard_contract_active'.tr(), AppColors.salesSuccess),
    'completed': ('dashboard_contract_completed'.tr(), AppColors.salesPrimary),
    'draft': ('dashboard_contract_draft'.tr(), AppColors.salesWarning),
    'cancelled': ('dashboard_contract_cancelled'.tr(), AppColors.salesError),
  };

  int get maxCount {
    if (contractsByStatus.isEmpty) return 1;
    final values = contractsByStatus.values.toList();
    return values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);
  }

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
            'dashboard_contracts_status'.tr(),
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 16.h),
          ...statusConfig.entries.map((entry) {
            final key = entry.key;
            final label = entry.value.$1;
            final color = entry.value.$2;
            final count = contractsByStatus[key] ?? 0;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _ContractStatusBar(
                label: label,
                count: count,
                color: color,
                maxCount: maxCount,
                theme: theme,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ContractStatusBar extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final int maxCount;
  final ThemeData theme;

  const _ContractStatusBar({
    required this.label,
    required this.count,
    required this.color,
    required this.maxCount,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final percent = maxCount > 0 ? (count / maxCount) : 0.0;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: SizedBox(
            height: 8.h,
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: borderColor.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
