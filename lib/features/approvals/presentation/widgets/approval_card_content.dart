import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/approval.dart';
import 'approval_card_utils.dart';

/// Content section displaying approval details based on type.
class ApprovalCardContent extends StatelessWidget {
  final Approval approval;

  const ApprovalCardContent({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContentByType(),
          SizedBox(height: AppSizes.p12.h),
          _ApprovalMetaInfo(approval: approval),
        ],
      ),
    );
  }

  Widget _buildContentByType() {
    return switch (approval.type) {
      ApprovalType.purchase => _PurchaseContent(approval: approval),
      ApprovalType.payment => _PaymentContent(approval: approval),
      ApprovalType.hr => _HRContent(approval: approval),
      ApprovalType.budget => _BudgetContent(approval: approval),
      ApprovalType.discount => _DiscountContent(approval: approval),
    };
  }
}

class _PurchaseContent extends StatelessWidget {
  final Approval approval;

  const _PurchaseContent({required this.approval});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'approvals_material'.tr(), value: approval.data['materialName'] ?? '-'),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(
          label: 'Summa',
          value: formatApprovalCurrency(approval.amount),
          valueColor: primaryColor,
          valueBold: true,
        ),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(label: 'Loyiha', value: approval.data['project'] ?? '-'),
      ],
    );
  }
}

class _PaymentContent extends StatelessWidget {
  final Approval approval;

  const _PaymentContent({required this.approval});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          label: 'Summa',
          value: formatApprovalCurrency(approval.amount),
          valueColor: primaryColor,
          valueBold: true,
        ),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(label: 'Kimga', value: approval.data['recipient'] ?? '-'),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(label: 'Maqsad', value: approval.data['purpose'] ?? '-'),
      ],
    );
  }
}

class _HRContent extends StatelessWidget {
  final Approval approval;

  const _HRContent({required this.approval});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;
    final isNewEmployee = approval.data['type'] == 'Yangi xodim';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Xodim', value: approval.data['employeeName'] ?? '-'),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(label: 'Lavozim', value: approval.data['position'] ?? '-'),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(
          label: isNewEmployee ? 'Maosh' : 'Yangi maosh',
          value: formatApprovalCurrency(approval.amount),
          valueColor: primaryColor,
          valueBold: true,
        ),
      ],
    );
  }
}

class _BudgetContent extends StatelessWidget {
  final Approval approval;

  const _BudgetContent({required this.approval});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Loyiha', value: approval.data['project'] ?? '-'),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(
          label: "Qo'shimcha",
          value: formatApprovalCurrency(approval.amount),
          valueColor: warningColor,
          valueBold: true,
        ),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(label: 'Sabab', value: approval.data['reason'] ?? '-'),
      ],
    );
  }
}

class _DiscountContent extends StatelessWidget {
  final Approval approval;

  const _DiscountContent({required this.approval});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Mijoz', value: approval.data['clientName'] ?? '-'),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(
          label: 'Kvartira',
          value: '${approval.data['apartment']}, ${approval.data['project']}',
        ),
        SizedBox(height: AppSizes.p8.h),
        _InfoRow(
          label: 'Chegirma',
          value:
              '${approval.data['discountPercent']}% (${formatApprovalCurrency(approval.amount)})',
          valueColor: successColor,
          valueBold: true,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tertiaryColor = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: tertiaryColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: valueColor ?? primaryTextColor,
              fontWeight: valueBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _ApprovalMetaInfo extends StatelessWidget {
  final Approval approval;

  const _ApprovalMetaInfo({required this.approval});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tertiaryColor = isDark ? AppColors.darkTextTertiary : AppColors.textTertiary;
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Row(
      children: [
        Icon(
          Icons.person_outline_rounded,
          size: 14.w,
          color: tertiaryColor,
        ),
        SizedBox(width: AppSizes.p4.w),
        Text(
          approval.requestedBy,
          style: AppTextStyles.caption.copyWith(
            color: tertiaryColor,
          ),
        ),
        SizedBox(width: AppSizes.p16.w),
        Icon(
          Icons.calendar_today_outlined,
          size: 14.w,
          color: tertiaryColor,
        ),
        SizedBox(width: AppSizes.p4.w),
        Text(
          dateFormat.format(approval.createdAt),
          style: AppTextStyles.caption.copyWith(
            color: tertiaryColor,
          ),
        ),
      ],
    );
  }
}
