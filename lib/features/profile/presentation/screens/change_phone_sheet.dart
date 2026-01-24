import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../bloc/profile_edit_bloc.dart';
import '../theme/profile_theme.dart';
import '../widgets/change_phone_widgets.dart';

/// Bottom sheet for changing phone number with OTP verification.
class ChangePhoneSheet extends StatefulWidget {
  final String currentPhone;

  const ChangePhoneSheet({
    super.key,
    required this.currentPhone,
  });

  @override
  State<ChangePhoneSheet> createState() => _ChangePhoneSheetState();
}

class _ChangePhoneSheetState extends State<ChangePhoneSheet> {
  late final TextEditingController _phoneController;
  late final TextEditingController _otpController;
  late final FocusNode _phoneFocus;
  late final FocusNode _otpFocus;

  bool _showOtpField = false;
  String? _phoneError;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _otpController = TextEditingController();
    _phoneFocus = FocusNode();
    _otpFocus = FocusNode();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _phoneFocus.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  bool _validatePhone() {
    setState(() => _phoneError = null);

    if (_phoneController.text.isEmpty) {
      setState(() => _phoneError = 'profile_change_phone_required'.tr());
      return false;
    }

    final phoneRegex = RegExp(r'^(\+998|0)\d{9}$');
    if (!phoneRegex.hasMatch(_phoneController.text.replaceAll(' ', ''))) {
      setState(() => _phoneError = 'profile_change_phone_invalid'.tr());
      return false;
    }

    if (_phoneController.text == widget.currentPhone) {
      setState(() => _phoneError = 'profile_change_phone_same'.tr());
      return false;
    }

    return true;
  }

  bool _validateOtp() {
    setState(() => _otpError = null);

    if (_otpController.text.isEmpty) {
      setState(() => _otpError = 'profile_change_phone_otp_required'.tr());
      return false;
    }

    if (_otpController.text.length != 6) {
      setState(() => _otpError = 'profile_change_phone_otp_length'.tr());
      return false;
    }

    return true;
  }

  void _requestPhoneChange() {
    if (!_validatePhone()) return;

    context.read<ProfileEditBloc>().add(
          RequestPhoneChange(newPhone: _phoneController.text),
        );
  }

  void _verifyPhoneChange() {
    if (!_validateOtp()) return;

    context.read<ProfileEditBloc>().add(
          VerifyPhoneChange(code: _otpController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return BlocListener<ProfileEditBloc, ProfileEditState>(
      listenWhen: (previous, current) {
        return previous.formStatus != current.formStatus &&
            (previous.isPhoneChangePending != current.isPhoneChangePending ||
                previous.isVerifyingPhone != current.isVerifyingPhone);
      },
      listener: (context, state) {
        if (state.formStatus == FormStatus.otpSent &&
            !state.isPhoneChangePending) {
          setState(() => _showOtpField = true);
          _otpFocus.requestFocus();
        }

        if (state.formStatus == FormStatus.success &&
            !state.isVerifyingPhone &&
            _showOtpField) {
          Navigator.of(context).pop();
          CustomSnacbar.show(
            context,
            text: 'profile_change_phone_success'.tr(),
          );
        }

        if (state.formStatus == FormStatus.failure &&
            state.errorMessage != null) {
          CustomSnacbar.show(
            context,
            text: state.errorMessage ?? 'common_error'.tr(),
            isError: true,
          );
        }
      },
      child: Container(
        color: colors.surface,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 24.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile_change_phone_title'.tr(),
                  style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
                ),
                SizedBox(height: 8.h),
                Text(
                  'profile_change_phone_subtitle'.tr(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 24.h),
                CurrentPhoneField(currentPhone: widget.currentPhone),
                SizedBox(height: 24.h),
                NewPhoneField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  errorText: _phoneError,
                ),
                SizedBox(height: 24.h),
                if (_showOtpField) ...[
                  OtpCodeField(
                    controller: _otpController,
                    focusNode: _otpFocus,
                    errorText: _otpError,
                  ),
                  SizedBox(height: 24.h),
                ],
                ChangePhoneActionButtons(
                  showOtpField: _showOtpField,
                  onCancel: () => Navigator.of(context).pop(),
                  onRequestChange: _requestPhoneChange,
                  onVerifyChange: _verifyPhoneChange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
