import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import 'premium_balance/premium_balance.dart';

class PremiumBalanceCard extends StatelessWidget {
  final String propertyName;
  final String unitNumber;
  final double outstandingBalance;
  final double progressPercent;
  final String nextPaymentDate;
  final double nextPaymentAmount;

  const PremiumBalanceCard({
    super.key,
    this.propertyName = 'Yuksalish Towers',
    this.unitNumber = 'Unit #412',
    this.outstandingBalance = 125000.00,
    this.progressPercent = 0.75,
    this.nextPaymentDate = 'Oct 15, 2023',
    this.nextPaymentAmount = 2500.00,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF003366),
            Color(0xFF1A4D80),
            Color(0xFF2D5F8A),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            // Background Decorative Elements
            Positioned(
              top: -40.h,
              right: -40.w,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -60.h,
              left: -30.w,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            // Subtle Grid Pattern
            Positioned.fill(
              child: CustomPaint(
                painter: PremiumGridPainter(),
              ),
            ),
            // Main Content
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PremiumBalanceHeader(
                    propertyName: propertyName,
                    unitNumber: unitNumber,
                  ),
                  SizedBox(height: 28.h),
                  Text(
                    'OUTSTANDING BALANCE',
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                      letterSpacing: 1.2,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  PremiumBalanceAmount(amount: outstandingBalance),
                  SizedBox(height: 28.h),
                  PremiumBalanceProgress(progressPercent: progressPercent),
                  SizedBox(height: 24.h),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  SizedBox(height: 20.h),
                  PremiumBalanceFooter(
                    nextPaymentDate: nextPaymentDate,
                    nextPaymentAmount: nextPaymentAmount,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
