import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/debt.dart';

/// Modal for viewing debt/contract details
class DebtDetailModal extends StatelessWidget {
  final Debt debt;

  const DebtDetailModal({
    super.key,
    required this.debt,
  });

  /// Show the debt detail modal
  static Future<void> show(
    BuildContext context, {
    required Debt debt,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DebtDetailModal(
        debt: debt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          _buildHeader(context),
          const Divider(height: 1),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBadge(),
                  SizedBox(height: AppSizes.p16.h),
                  _buildClientSection(context),
                  SizedBox(height: AppSizes.p20.h),
                  _buildContractSection(context),
                  SizedBox(height: AppSizes.p20.h),
                  _buildProgressSection(context),
                  SizedBox(height: AppSizes.p20.h),
                  _buildAmountSection(context),
                  SizedBox(height: AppSizes.p24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      margin: EdgeInsets.only(top: AppSizes.p12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(AppSizes.p16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'finance_debt_detail'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.close_rounded,
              color: theme.textTheme.bodySmall?.color,
              size: 24.w,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final (color, bgColor, icon) = switch (debt.status) {
      DebtStatus.active => (
          AppColors.info,
          AppColors.infoLight,
          Icons.schedule_rounded
        ),
      DebtStatus.overdue => (
          AppColors.error,
          AppColors.errorLight,
          Icons.warning_amber_rounded
        ),
      DebtStatus.paidOff => (
          AppColors.success,
          AppColors.successLight,
          Icons.check_circle_rounded
        ),
    };

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p12.w,
            vertical: AppSizes.p8.h,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.w, color: color),
              SizedBox(width: AppSizes.p8.w),
              Text(
                debt.status.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (debt.overdueDays > 0) ...[
          SizedBox(width: AppSizes.p8.w),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p12.w,
              vertical: AppSizes.p8.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
            ),
            child: Text(
              'finance_days_late'.tr(namedArgs: {'days': debt.overdueDays.toString()}),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildClientSection(BuildContext context) {
    return _buildSection(
      context: context,
      title: 'finance_client_info'.tr(),
      children: [
        _buildInfoRow(
          context: context,
          icon: Icons.person_rounded,
          label: 'finance_name'.tr(),
          value: debt.clientName,
        ),
        _buildInfoRow(
          context: context,
          icon: Icons.phone_rounded,
          label: 'finance_phone'.tr(),
          value: debt.formattedPhone,
        ),
        if (debt.assignedToName != null)
          _buildInfoRow(
            context: context,
            icon: Icons.support_agent_rounded,
            label: 'finance_responsible'.tr(),
            value: debt.assignedToName!,
          ),
      ],
    );
  }

  Widget _buildContractSection(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    return _buildSection(
      context: context,
      title: 'finance_contract'.tr(),
      children: [
        _buildInfoRow(
          context: context,
          icon: Icons.description_rounded,
          label: 'finance_contract_number'.tr(),
          value: debt.contractNumber,
        ),
        _buildInfoRow(
          context: context,
          icon: Icons.apartment_rounded,
          label: 'finance_project_apartment'.tr(),
          value: '${debt.projectName} • ${debt.apartmentNumber}',
        ),
        _buildInfoRow(
          context: context,
          icon: Icons.category_rounded,
          label: 'finance_contract_type'.tr(),
          value: _getContractTypeLabel(),
        ),
        if (debt.signedAt != null)
          _buildInfoRow(
            context: context,
            icon: Icons.calendar_today_rounded,
            label: 'finance_signed_date'.tr(),
            value: dateFormat.format(debt.signedAt!),
          ),
        if (debt.nextPaymentDate != null)
          _buildInfoRow(
            context: context,
            icon: Icons.event_rounded,
            label: "finance_next_payment_date".tr(),
            value: dateFormat.format(debt.nextPaymentDate!),
          ),
      ],
    );
  }

  String _getContractTypeLabel() {
    return switch (debt.contractType) {
      ContractType.cash => 'finance_contract_type_cash'.tr(),
      ContractType.installment => 'finance_contract_type_installment'.tr(),
      ContractType.mortgage => 'finance_contract_type_mortgage'.tr(),
    };
  }

  Widget _buildProgressSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBorder : AppColors.border;
    final progressColor = _getProgressColor();

    return _buildSection(
      context: context,
      title: 'finance_payment_status'.tr(),
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
          child: LinearProgressIndicator(
            value: debt.paidPercentage / 100,
            backgroundColor: bgColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 12.h,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'finance_paid'.tr(),
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                Text(
                  '${debt.paidPercentage.toStringAsFixed(1)}%',
                  style: AppTextStyles.h4.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'finance_remaining_debt'.tr(),
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                Text(
                  '${(100 - debt.paidPercentage).toStringAsFixed(1)}%',
                  style: AppTextStyles.h4.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Color _getProgressColor() {
    if (debt.paidPercentage >= 80) {
      return AppColors.success;
    } else if (debt.paidPercentage >= 50) {
      return AppColors.info;
    } else if (debt.paidPercentage >= 30) {
      return AppColors.warning;
    }
    return AppColors.error;
  }

  Widget _buildAmountSection(BuildContext context) {
    final theme = Theme.of(context);

    return _buildSection(
      context: context,
      title: 'finance_amount_info'.tr(),
      children: [
        _buildAmountRow(
          context: context,
          label: 'finance_total_amount'.tr(),
          value: debt.formattedTotalAmount,
          color: theme.textTheme.titleMedium?.color ?? AppColors.textPrimary,
        ),
        _buildAmountRow(
          context: context,
          label: 'finance_paid'.tr(),
          value: debt.formattedPaidAmount,
          color: AppColors.success,
        ),
        _buildAmountRow(
          context: context,
          label: 'finance_remaining_debt'.tr(),
          value: debt.formattedRemainingAmount,
          color: AppColors.warning,
        ),
        if (debt.overdueAmount > 0)
          _buildAmountRow(
            context: context,
            label: 'finance_overdue'.tr(),
            value: debt.formattedOverdueAmount,
            color: AppColors.error,
          ),
        _buildAmountRow(
          context: context,
          label: 'finance_monthly_payment'.tr(),
          value: debt.formattedMonthlyPayment,
          color: theme.textTheme.bodySmall?.color ?? AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.p12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.p8.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.w,
            color: theme.textTheme.bodySmall?.color,
          ),
          SizedBox(width: AppSizes.p8.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow({
    required BuildContext context,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.p8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
