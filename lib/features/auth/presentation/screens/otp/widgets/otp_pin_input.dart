import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../core/constants/app_colors.dart';

/// OTP PIN input field using Pinput package.
class OtpPinInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onCompleted;

  const OtpPinInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 64.h,
      textStyle: GoogleFonts.urbanist(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: theme.textTheme.titleLarge?.color,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.5,
        ),
      ),
    );

    return AutofillGroup(
      child: Pinput(
        controller: controller,
        focusNode: focusNode,
        length: 6,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        showCursor: true,
        cursor: Container(
          width: 2,
          height: 24.h,
          color: theme.colorScheme.primary,
        ),
        onCompleted: onCompleted,
        autofillHints: const [AutofillHints.oneTimeCode],
        readOnly: Platform.isAndroid,
        enabled: true,
      ),
    );
  }
}
