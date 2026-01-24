import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

/// Resend code section with timer countdown.
class OtpResendSection extends StatelessWidget {
  final bool canResend;
  final int remainingSeconds;
  final VoidCallback onResend;

  const OtpResendSection({
    super.key,
    required this.canResend,
    required this.remainingSeconds,
    required this.onResend,
  });

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.textTheme.bodySmall?.color;

    return Column(
      children: [
        Text(
          'auth_otp_didnt_receive'.tr(),
          style: GoogleFonts.urbanist(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: secondaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: canResend ? onResend : null,
              child: Text(
                'auth_otp_resend'.tr(),
                style: GoogleFonts.urbanist(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: canResend ? theme.colorScheme.primary : secondaryColor,
                ),
              ),
            ),
            if (!canResend) ...[
              SizedBox(width: 8.w),
              Container(
                width: 4.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                _formatTime(remainingSeconds),
                style: GoogleFonts.urbanist(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: secondaryColor,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
