import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/finance_bloc.dart';

class PaymentDetailsSheet extends StatelessWidget {
  const PaymentDetailsSheet({super.key, required this.payment});

  final Payment payment;

  static void show(BuildContext context, Payment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentDetailsSheet(payment: payment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: AppSizes.p12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSizes.p24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'finance_payment_details'.tr(),
                      style: AppTextStyles.h3.copyWith(
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.p20.h),
                // Status badge
                _buildStatusBadge(context),
                SizedBox(height: AppSizes.p16.h),
                // Receipt number
                _PaymentDetailRow(label: 'finance_receipt'.tr(), value: '#${payment.receiptNumber}'),
                _PaymentDetailRow(label: 'finance_client'.tr(), value: payment.clientName),
                _PaymentDetailRow(label: 'finance_contract'.tr(), value: payment.contractNumber),
                _PaymentDetailRow(label: 'finance_project'.tr(), value: payment.projectName ?? '-'),
                _PaymentDetailRow(label: 'finance_amount'.tr(), value: payment.formattedAmount),
                _PaymentDetailRow(label: 'finance_payment_type'.tr(), value: payment.typeLabel),
                _PaymentDetailRow(label: 'finance_date_label'.tr(), value: _formatDate(payment.date)),
                if (payment.processedBy != null)
                  _PaymentDetailRow(label: 'finance_processed_by_label'.tr(), value: payment.processedBy!),
                SizedBox(height: AppSizes.p24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);

    final color = switch (payment.status) {
      PaymentStatus.completed => AppColors.success,
      PaymentStatus.pending => AppColors.warning,
      PaymentStatus.overdue => AppColors.error,
      PaymentStatus.cancelled => theme.textTheme.bodySmall?.color ?? AppColors.textTertiary,
    };
    final bgColor = switch (payment.status) {
      PaymentStatus.completed => AppColors.successLight,
      PaymentStatus.pending => AppColors.warningLight,
      PaymentStatus.overdue => AppColors.errorLight,
      PaymentStatus.cancelled => theme.scaffoldBackgroundColor,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12.w,
        vertical: AppSizes.p8.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Text(
        payment.statusLabel,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _PaymentDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.p12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: theme.textTheme.titleMedium?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
