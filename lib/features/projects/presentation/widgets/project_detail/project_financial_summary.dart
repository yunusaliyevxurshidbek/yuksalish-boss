import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';

/// Financial row data model.
class FinancialRow {
  final String label;
  final String value;
  final Color color;

  const FinancialRow({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Financial summary section for project detail.
class ProjectFinancialSummary extends StatelessWidget {
  final List<FinancialRow> items;

  const ProjectFinancialSummary({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      children: [
        const SectionHeader(title: "Moliyaviy ko'rsatkichlar"),
        SizedBox(height: AppSizes.p16.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
          padding: EdgeInsets.all(AppSizes.p16.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final item = entry.value;
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  _FinanceRow(item: item),
                  if (!isLast) Divider(height: AppSizes.p24.h, color: borderColor),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _FinanceRow extends StatelessWidget {
  final FinancialRow item;

  const _FinanceRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
            ),
            SizedBox(width: AppSizes.p8.w),
            Text(
              item.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        Text(
          item.value,
          style: AppTextStyles.labelLarge.copyWith(
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
      ],
    );
  }
}
