import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

/// Security badge footer.
class SecurityFooter extends StatelessWidget {
  const SecurityFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 14.sp,
            color: theme.textTheme.bodySmall?.color ??
                theme.colorScheme.onSurface,
          ),
          SizedBox(width: 6.w),
          Text(
            'auth_pin_security_badge'.tr(),
            style: GoogleFonts.urbanist(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodySmall?.color ??
                  theme.colorScheme.onSurface,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
