import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

/// Subtitle widget showing verification message and phone number.
class OtpSubtitle extends StatelessWidget {
  final String phoneNumber;

  const OtpSubtitle({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'auth_otp_subtitle'.tr(),
        style: GoogleFonts.urbanist(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: theme.textTheme.bodySmall?.color,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: phoneNumber,
            style: GoogleFonts.urbanist(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
