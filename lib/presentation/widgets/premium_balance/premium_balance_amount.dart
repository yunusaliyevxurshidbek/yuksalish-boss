import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Formats number with comma separators.
String formatWithCommas(String number) {
  return number.replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
}

/// Large balance amount display with dollar sign.
class PremiumBalanceAmount extends StatelessWidget {
  final double amount;

  const PremiumBalanceAmount({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final parts = amount.toStringAsFixed(2).split('.');
    final integerPart = formatWithCommas(parts[0]);
    final decimalPart = parts[1];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Text(
            '\$',
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
        Text(
          integerPart,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            fontSize: 36.sp,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Text(
            '.$decimalPart',
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

/// Smaller payment amount display.
class PremiumPaymentAmount extends StatelessWidget {
  final double amount;

  const PremiumPaymentAmount({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    final parts = amount.toStringAsFixed(0);
    final formatted = formatWithCommas(parts);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '\$',
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          TextSpan(
            text: formatted,
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
