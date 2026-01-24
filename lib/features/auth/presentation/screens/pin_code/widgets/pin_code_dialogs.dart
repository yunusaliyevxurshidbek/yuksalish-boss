import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

/// Dialog for confirming PIN reset.
class ResetPinDialog extends StatelessWidget {
  const ResetPinDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ResetPinDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(
            Icons.lock_reset,
            color: theme.colorScheme.primary,
            size: 28.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'auth_pin_dialog_reset_title'.tr(),
              style: GoogleFonts.urbanist(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color ??
                    theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        'auth_pin_dialog_reset_message'.tr(),
        style: GoogleFonts.urbanist(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: theme.textTheme.bodyMedium?.color ??
              theme.colorScheme.onSurface,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'auth_pin_dialog_cancel'.tr(),
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color ??
                  theme.colorScheme.onSurface,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'auth_pin_dialog_send_code'.tr(),
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Dialog for enabling biometric authentication.
class EnableBiometricDialog extends StatelessWidget {
  const EnableBiometricDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const EnableBiometricDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(
            Icons.fingerprint,
            color: theme.colorScheme.primary,
            size: 28.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'auth_pin_dialog_biometric_title'.tr(),
              style: GoogleFonts.urbanist(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color ??
                    theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        'auth_pin_dialog_biometric_message'.tr(),
        style: GoogleFonts.urbanist(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: theme.textTheme.bodyMedium?.color ??
              theme.colorScheme.onSurface,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'auth_pin_dialog_not_now'.tr(),
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color ??
                  theme.colorScheme.onSurface,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'auth_pin_dialog_enable'.tr(),
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Loading dialog while sending OTP.
class SendingCodeDialog extends StatelessWidget {
  const SendingCodeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      content: Row(
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 20.w),
          Text(
            'auth_otp_sending'.tr(),
            style: GoogleFonts.urbanist(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyMedium?.color ??
                  theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
