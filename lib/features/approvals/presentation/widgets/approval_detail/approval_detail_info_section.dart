import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/widgets.dart';

/// Info section with rows of label-value pairs.
class ApprovalDetailInfoSection extends StatelessWidget {
  final String title;
  final List<ApprovalDetailRow> rows;

  const ApprovalDetailInfoSection({
    super.key,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        SizedBox(height: AppSizes.p12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
          padding: EdgeInsets.all(AppSizes.p16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          ),
          child: Column(
            children: List.generate(rows.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Divider(height: AppSizes.p24.h, color: AppColors.divider);
              }
              final row = rows[index ~/ 2];
              return _DetailRow(label: row.label, value: row.value);
            }),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.labelMedium),
      ],
    );
  }
}

/// Data class for a detail row.
class ApprovalDetailRow {
  final String label;
  final String value;

  const ApprovalDetailRow(this.label, this.value);
}
