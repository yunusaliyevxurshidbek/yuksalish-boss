import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/sales_dynamics_models.dart';

/// Section showing sales transaction history.
class TransactionsSection extends StatelessWidget {
  final List<SalesTransaction> transactions;
  final VoidCallback? onExportPressed;

  const TransactionsSection({
    super.key,
    required this.transactions,
    this.onExportPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'dashboard_sales_history'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.salesTextPrimary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onExportPressed,
              icon: Icon(
                Icons.download_rounded,
                size: 16.w,
                color: AppColors.salesPrimary,
              ),
              label: Text(
                'dashboard_export'.tr(),
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.salesPrimary,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.salesPrimary,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                backgroundColor: AppColors.salesPrimary.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Column(
          children: transactions.map((transaction) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _TransactionCard(transaction: transaction),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final SalesTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isSold = transaction.status == TransactionStatus.sold;
    final statusLabel = isSold ? 'dashboard_status_sold'.tr() : 'dashboard_status_reserved'.tr();
    final statusColor = isSold ? AppColors.salesSuccess : AppColors.salesWarning;
    final statusBackground =
        isSold ? AppColors.salesSuccessLight : AppColors.salesWarningLight;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.salesCard,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.salesShadow.withValues(alpha: 0.06),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.salesPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.home_work_outlined,
              size: 20.w,
              color: AppColors.salesPrimary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.unit,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.salesTextPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.client,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.salesTextSecondary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  transaction.price,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.salesTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                transaction.date,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.salesTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
