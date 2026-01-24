import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/profile_theme.dart';

/// Styled text field for profile forms.
class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? suffixIcon;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          style: AppTextStyles.bodyMedium.copyWith(
            color: enabled ? colors.textPrimary : colors.textTertiary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? colors.surface : colors.surfaceElevated,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16.w,
              vertical: AppSizes.p12.h,
            ),
            border: _buildBorder(colors.border),
            enabledBorder: _buildBorder(colors.border),
            focusedBorder: _buildBorder(colors.primary, width: 1.5),
            errorBorder: _buildBorder(colors.error),
            disabledBorder: _buildBorder(colors.divider),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
