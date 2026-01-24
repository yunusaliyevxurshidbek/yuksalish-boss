import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/injection_container.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/reset_password/reset_password_cubit.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/reset_password/reset_password_state.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_button_universal.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_snacbar.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_text_field.dart';

class ResetPassword extends StatefulWidget {
  final String phone;
  final String code;

  const ResetPassword({
    super.key,
    required this.phone,
    required this.code,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _onUpdatePassword(BuildContext context) {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'auth_reset_password_required'.tr(),
        isError: true,
      );
      return;
    }

    if (newPassword.length < 6) {
      CustomSnacbar.show(
        context,
        text: 'auth_reset_password_min_length'.tr(),
        isError: true,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      CustomSnacbar.show(
        context,
        text: 'auth_reset_password_mismatch'.tr(),
        isError: true,
      );
      return;
    }

    context.read<ResetPasswordCubit>().resetPassword(
          phone: widget.phone,
          code: widget.code,
          newPassword: newPassword,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            CustomSnacbar.show(
              context,
              text: state.response.message,
            );
            if (context.mounted) {
              context.go('/login_page');
            }
          } else if (state is ResetPasswordError) {
            CustomSnacbar.show(
              context,
              text: state.message,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ResetPasswordLoading;
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Column(
              children: [
                _buildCurvedHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        Center(
                          child: Text(
                            'auth_reset_title'.tr(),
                            style: GoogleFonts.urbanist(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Center(
                          child: Text(
                            'auth_reset_subtitle'.tr(),
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodySmall?.color,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        CustomTextField(
                          label: 'auth_reset_new_password_label'.tr(),
                          controller: _newPasswordController,
                          focusNode: _newPasswordFocus,
                          prefixIcon: Icons.lock_outline,
                          hintText: 'auth_reset_new_password_hint'.tr(),
                          obscureText: _obscureNewPassword,
                          textInputAction: TextInputAction.next,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: theme.textTheme.bodySmall?.color,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                          onFieldSubmitted: (_) {
                            _confirmPasswordFocus.requestFocus();
                          },
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          label: 'auth_reset_confirm_label'.tr(),
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          prefixIcon: Icons.lock_outline,
                          hintText: 'auth_reset_confirm_hint'.tr(),
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: theme.textTheme.bodySmall?.color,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          onFieldSubmitted: (_) {
                            _onUpdatePassword(context);
                          },
                        ),
                        SizedBox(height: 40.h),
                        PressableButton(
                          text: isLoading ? 'auth_reset_updating'.tr() : 'auth_reset_button'.tr(),
                          onTap: isLoading
                              ? null
                              : () => _onUpdatePassword(context),
                          backgroundColor: theme.colorScheme.primary,
                          textColor: Colors.white,
                          width: double.infinity,
                          height: 56.h,
                          borderRadius: 12,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurvedHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: 360.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.r),
          bottomRight: Radius.circular(50.r),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8.h,
              left: 8.w,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24.sp,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/logo_for_dark.png',
                width: 200.w,
                height: 200.h,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
