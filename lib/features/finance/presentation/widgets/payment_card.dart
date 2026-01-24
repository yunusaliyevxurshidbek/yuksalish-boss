import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/payment_model.dart';

/// Card widget for displaying a payment transaction.
class PaymentCard extends StatelessWidget {
  final PaymentModel payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final statusColors = getStatusColor(payment.status);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: 10.h),
          _buildClientName(context),
          SizedBox(height: 8.h),
          _buildContractInfo(context),
          SizedBox(height: 12.h),
          _buildFooter(context, statusColors),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            payment.transactionId,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Text(
          payment.amount,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildClientName(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            payment.clientName,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContractInfo(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.textTheme.bodySmall?.color;

    return Row(
      children: [
        Icon(
          Icons.description_outlined,
          size: 14.w,
          color: secondaryColor,
        ),
        SizedBox(width: 6.w),
        Text(
          payment.contractInfo,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: secondaryColor,
          ),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: secondaryColor?.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        Icon(
          Icons.credit_card_rounded,
          size: 14.w,
          color: secondaryColor,
        ),
        SizedBox(width: 6.w),
        Text(
          payment.method,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, StatusColors statusColors) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            payment.date,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: statusColors.background,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            payment.status,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: statusColors.text,
            ),
          ),
        ),
      ],
    );
  }
}
