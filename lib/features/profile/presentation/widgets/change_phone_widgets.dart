import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../bloc/profile_edit_bloc.dart';
import '../theme/profile_theme.dart';

class CurrentPhoneField extends StatelessWidget {
  final String currentPhone;

  const CurrentPhoneField({super.key, required this.currentPhone});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile_phone_current_label'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: currentPhone,
            filled: true,
            fillColor: colors.surfaceElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.border),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }
}

class NewPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;

  const NewPhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile_phone_new_label'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        BlocBuilder<ProfileEditBloc, ProfileEditState>(
          buildWhen: (previous, current) =>
              previous.isPhoneChangePending != current.isPhoneChangePending,
          builder: (context, state) {
            final colors = ProfileThemeColors.of(context);
            return TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: !state.isPhoneChangePending,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'profile_phone_hint'.tr(),
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
                filled: true,
                fillColor: colors.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.border),
                ),
                errorText: errorText,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class OtpCodeField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;

  const OtpCodeField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile_phone_otp_label'.tr(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'profile_phone_otp_hint'.tr(),
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
            counterText: '',
            filled: true,
            fillColor: colors.surfaceElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
            errorText: errorText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'profile_phone_otp_wait'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class ChangePhoneActionButtons extends StatelessWidget {
  final bool showOtpField;
  final VoidCallback onCancel;
  final VoidCallback onRequestChange;
  final VoidCallback onVerifyChange;

  const ChangePhoneActionButtons({
    super.key,
    required this.showOtpField,
    required this.onCancel,
    required this.onRequestChange,
    required this.onVerifyChange,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileEditBloc, ProfileEditState>(
      buildWhen: (previous, current) =>
          previous.isPhoneChangePending != current.isPhoneChangePending ||
          previous.isVerifyingPhone != current.isVerifyingPhone,
      builder: (context, state) {
        final colors = ProfileThemeColors.of(context);
        final isLoading = state.isPhoneChangePending || state.isVerifyingPhone;
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.primary),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'common_cancel'.tr(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : (showOtpField ? onVerifyChange : onRequestChange),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  disabledBackgroundColor: colors.primary.withValues(alpha: 0.5),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(colors.textOnPrimary),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        showOtpField
                            ? 'common_confirm'.tr()
                            : 'profile_phone_send_code'.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colors.textOnPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
