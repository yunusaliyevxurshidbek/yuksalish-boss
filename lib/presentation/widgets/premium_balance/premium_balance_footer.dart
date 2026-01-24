import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'premium_balance_amount.dart';

/// Footer with next payment due info.
class PremiumBalanceFooter extends StatelessWidget {
  final String nextPaymentDate;
  final double nextPaymentAmount;

  const PremiumBalanceFooter({
    super.key,
    required this.nextPaymentDate,
    required this.nextPaymentAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Next Payment Due',
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              nextPaymentDate,
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Amount',
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 4.h),
            PremiumPaymentAmount(amount: nextPaymentAmount),
          ],
        ),
      ],
    );
  }
}
