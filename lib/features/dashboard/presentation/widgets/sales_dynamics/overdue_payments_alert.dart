import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/overdue_payment_model.dart';
import 'summary_cards.dart';

/// Overdue payments alert section
class OverduePaymentsAlert extends StatelessWidget {
  final List<OverduePaymentModel> payments;
  final VoidCallback? onViewAllPressed;

  const OverduePaymentsAlert({
    super.key,
    required this.payments,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final errorColor = theme.colorScheme.error;

    if (payments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: errorColor.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 20.w,
                  color: errorColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'dashboard_overdue_payments'.tr(namedArgs: {'count': '${payments.length}'}),
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: errorColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Payment items
          ...payments.take(3).map((payment) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _OverduePaymentItem(payment: payment, theme: theme),
              )),
          if (payments.length > 3) ...[
            SizedBox(height: 4.h),
            TextButton(
              onPressed: onViewAllPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'dashboard_view_all'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: errorColor,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16.w,
                    color: errorColor,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OverduePaymentItem extends StatelessWidget {
  final OverduePaymentModel payment;
  final ThemeData theme;

  const _OverduePaymentItem({required this.payment, required this.theme});

  String get _shortClientName {
    final parts = payment.clientName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1][0]}.';
    }
    return payment.clientName;
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = theme.colorScheme.error;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 16.w,
              color: errorColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.contractNumber,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _shortClientName,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(payment.amount),
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
