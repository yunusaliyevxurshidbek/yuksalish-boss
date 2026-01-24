import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../bloc/profile_edit_bloc.dart';
import '../theme/profile_theme.dart';
import '../widgets/change_password_widgets.dart';

/// Dialog for changing password.
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _oldPasswordFocus;
  late final FocusNode _newPasswordFocus;
  late final FocusNode _confirmPasswordFocus;

  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _oldPasswordFocus = FocusNode();
    _newPasswordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _oldPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  bool _validatePasswords() {
    setState(() {
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    if (_newPasswordController.text.isEmpty) {
      setState(() => _newPasswordError = 'profile_change_password_new_required'.tr());
      return false;
    }

    if (_newPasswordController.text.length < 8) {
      setState(() => _newPasswordError = 'profile_change_password_min_length'.tr());
      return false;
    }

    if (_confirmPasswordController.text.isEmpty) {
      setState(
        () => _confirmPasswordError =
            'profile_change_password_confirm_required'.tr(),
      );
      return false;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _confirmPasswordError = 'profile_change_password_mismatch'.tr());
      return false;
    }

    return true;
  }

  void _handleSubmit() {
    if (_oldPasswordController.text.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'profile_change_password_old_required'.tr(),
        isError: true,
      );
      return;
    }

    if (!_validatePasswords()) {
      return;
    }

    context.read<ProfileEditBloc>().add(
          ChangePassword(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: BlocListener<ProfileEditBloc, ProfileEditState>(
        listenWhen: (previous, current) {
          return previous.isChangingPassword != current.isChangingPassword ||
              (previous.formStatus != current.formStatus &&
                  previous.isChangingPassword);
        },
        listener: (context, state) {
          if (state.formStatus == FormStatus.success &&
              !state.isChangingPassword) {
            Navigator.of(context).pop();
            CustomSnacbar.show(
              context,
              text: 'profile_change_password_success'.tr(),
            );
          }

          if (state.formStatus == FormStatus.failure &&
              !state.isChangingPassword &&
              state.errorMessage != null) {
            CustomSnacbar.show(
              context,
              text: state.errorMessage ?? 'common_error'.tr(),
              isError: true,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile_change_password_title'.tr(),
                  style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
                ),
                SizedBox(height: 24.h),
                PasswordTextField(
                  label: 'profile_change_password_old_label'.tr(),
                  hint: 'profile_change_password_old_hint'.tr(),
                  controller: _oldPasswordController,
                  focusNode: _oldPasswordFocus,
                  nextFocusNode: _newPasswordFocus,
                  obscureText: !_showOldPassword,
                  onToggleVisibility: () {
                    setState(() => _showOldPassword = !_showOldPassword);
                  },
                ),
                SizedBox(height: 24.h),
                PasswordTextField(
                  label: 'profile_change_password_new_label'.tr(),
                  hint: 'profile_change_password_new_hint'.tr(),
                  controller: _newPasswordController,
                  focusNode: _newPasswordFocus,
                  nextFocusNode: _confirmPasswordFocus,
                  obscureText: !_showNewPassword,
                  onToggleVisibility: () {
                    setState(() => _showNewPassword = !_showNewPassword);
                  },
                  errorText: _newPasswordError,
                ),
                SizedBox(height: 24.h),
                PasswordTextField(
                  label: 'profile_change_password_confirm_label'.tr(),
                  hint: 'profile_change_password_confirm_hint'.tr(),
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  obscureText: !_showConfirmPassword,
                  onToggleVisibility: () {
                    setState(() => _showConfirmPassword = !_showConfirmPassword);
                  },
                  errorText: _confirmPasswordError,
                  onSubmitted: _handleSubmit,
                ),
                SizedBox(height: 32.h),
                ChangePasswordActionButtons(
                  onCancel: () => Navigator.of(context).pop(),
                  onSubmit: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
