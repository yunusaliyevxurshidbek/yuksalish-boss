import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/payment.dart';

/// List item widget for displaying a payment record
class PaymentListItem extends StatelessWidget {
  const PaymentListItem({
    super.key,
    required this.payment,
    this.onTap,
  });

  final Payment payment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.p12.h),
        padding: EdgeInsets.all(AppSizes.p16.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          border: Border.all(
            color: borderColor,
            width: AppSizes.borderThin,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: receipt number and amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${payment.receiptNumber}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${payment.formattedAmount} UZS',
                  style: AppTextStyles.h4.copyWith(
                    color: theme.textTheme.titleMedium?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.p8.h),
            // Client name
            Text(
              payment.clientName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: AppSizes.p8.h),
            // Contract and payment type
            Row(
              children: [
                Text(
                  payment.contractNumber,
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                SizedBox(width: AppSizes.p8.w),
                Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: theme.textTheme.bodySmall?.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSizes.p8.w),
                Icon(
                  _getPaymentTypeIcon(payment.type),
                  size: AppSizes.iconS.w,
                  color: theme.textTheme.bodySmall?.color,
                ),
                SizedBox(width: AppSizes.p4.w),
                Text(
                  payment.typeLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.p12.h),
            // Date and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd.MM.yyyy').format(payment.date),
                  style: AppTextStyles.caption.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                _buildStatusBadge(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentTypeIcon(PaymentType type) {
    return switch (type) {
      PaymentType.cash => Icons.payments_rounded,
      PaymentType.card => Icons.credit_card_rounded,
      PaymentType.transfer => Icons.account_balance_rounded,
      PaymentType.akt => Icons.description_rounded,
    };
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);

    final (color, bgColor, icon) = switch (payment.status) {
      PaymentStatus.completed => (
          AppColors.success,
          AppColors.successLight,
          Icons.check_circle_rounded,
        ),
      PaymentStatus.pending => (
          AppColors.warning,
          AppColors.warningLight,
          Icons.schedule_rounded,
        ),
      PaymentStatus.overdue => (
          AppColors.error,
          AppColors.errorLight,
          Icons.warning_amber_rounded,
        ),
      PaymentStatus.cancelled => (
          theme.textTheme.bodySmall?.color ?? AppColors.textTertiary,
          theme.scaffoldBackgroundColor,
          Icons.cancel_rounded,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p8.w,
        vertical: AppSizes.p4.h,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.w,
            color: color,
          ),
          SizedBox(width: AppSizes.p4.w),
          Text(
            payment.statusLabel,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
