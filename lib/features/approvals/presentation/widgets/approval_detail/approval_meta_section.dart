import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_colors.dart';

/// Section showing metadata like requester and date.
class ApprovalMetaSection extends StatelessWidget {
  final String requestedBy;
  final DateTime createdAt;

  const ApprovalMetaSection({
    super.key,
    required this.requestedBy,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy, HH:mm');
    return Container(
      padding: EdgeInsets.all(AppSizes.p12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Column(
        children: [
          _MetaRow(
            icon: Icons.person_outline_rounded,
            label: "So'rovchi",
            value: requestedBy,
          ),
          SizedBox(height: AppSizes.p8.h),
          _MetaRow(
            icon: Icons.calendar_today_outlined,
            label: 'Sana',
            value: dateFormat.format(createdAt),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.iconS.w,
          color: AppColors.textTertiary,
        ),
        SizedBox(width: AppSizes.p8.w),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
