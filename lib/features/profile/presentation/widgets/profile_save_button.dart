import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/profile_theme.dart';

/// Save button for profile forms.
class ProfileSaveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const ProfileSaveButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.text = 'common_save',
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colors.textOnPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_outlined, size: AppSizes.iconM.w),
                  SizedBox(width: 8.w),
                  Text(text.tr(), style: AppTextStyles.button),
                ],
              ),
      ),
    );
  }
}
