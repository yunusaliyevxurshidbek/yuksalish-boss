import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

/// Toggle widget for enabling/disabling biometric authentication.
class BiometricToggle extends StatelessWidget {
  final bool isEnabled;
  final bool isAvailable;
  final ValueChanged<bool>? onChanged;

  const BiometricToggle({
    super.key,
    required this.isEnabled,
    required this.isAvailable,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isAvailable
        ? (theme.textTheme.titleMedium?.color ?? theme.colorScheme.onSurface)
        : theme.disabledColor;
    final iconColor =
        isAvailable ? theme.colorScheme.primary : theme.disabledColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor
                .withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.fingerprint,
                color: iconColor,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'auth_pin_biometric_toggle'.tr(),
                style: GoogleFonts.urbanist(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          CupertinoSwitch(
            value: isEnabled,
            activeTrackColor: theme.colorScheme.primary,
            onChanged: isAvailable ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
