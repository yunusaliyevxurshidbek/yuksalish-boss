import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class SoldApartmentsProjectChart extends StatelessWidget {
  final Map<String, int> distribution;

  const SoldApartmentsProjectChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    if (distribution.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedEntries = distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topProjects = sortedEntries.take(5).toList();
    final total = distribution.values.fold(0, (a, b) => a + b);

    return Container(
      padding: EdgeInsets.all(AppSizes.p20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sold_apartments_by_projects'.tr(),
            style: AppTextStyles.h4.copyWith(
              color: theme.textTheme.titleLarge?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.p16.h),
          ...topProjects.asMap().entries.map((entry) {
            final index = entry.key;
            final project = entry.value;
            final percentage = total > 0 ? (project.value / total * 100) : 0.0;

            return Padding(
              padding: EdgeInsets.only(bottom: AppSizes.p12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          project.key,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${project.value} ta',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: borderColor,
                      valueColor: AlwaysStoppedAnimation(
                        _getProjectColor(index),
                      ),
                      minHeight: 8.h,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getProjectColor(int index) {
    const colors = [
      Color(0xFF6366F1),
      Color(0xFF22C55E),
      Color(0xFF3B82F6),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
    ];
    return colors[index % colors.length];
  }
}
