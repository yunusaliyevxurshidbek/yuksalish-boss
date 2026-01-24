import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/services/my_shared_preferences.dart';
import 'package:yuksalish_mobile/injection_container.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/set_password/set_password_cubit.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/set_password/set_password_state.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_button_universal.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_snacbar.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_text_field.dart';

class SetUpUserInfoPage extends StatefulWidget {
  final String phoneNumber;
  final String name;

  const SetUpUserInfoPage({
    super.key,
    this.phoneNumber = '',
    this.name = '',
  });

  @override
  State<SetUpUserInfoPage> createState() => _SetUpUserInfoPageState();
}

class _SetUpUserInfoPageState extends State<SetUpUserInfoPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.name.isNotEmpty) {
      _fullNameController.text = widget.name;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _onContinue(BuildContext context) {
    final fullName = _fullNameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (fullName.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'auth_setup_fullname_required'.tr(),
        isError: true,
      );
      return;
    }

    if (password.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'auth_setup_password_required'.tr(),
        isError: true,
      );
      return;
    }

    if (password.length < 6) {
      CustomSnacbar.show(
        context,
        text: 'auth_setup_password_min_length'.tr(),
        isError: true,
      );
      return;
    }

    if (password != confirmPassword) {
      CustomSnacbar.show(
        context,
        text: 'auth_setup_password_mismatch'.tr(),
        isError: true,
      );
      return;
    }

    final phone = widget.phoneNumber.trim();
    if (phone.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'auth_setup_phone_required'.tr(),
        isError: true,
      );
      return;
    }

    context.read<SetPasswordCubit>().submit(
          phone: phone,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SetPasswordCubit>(),
      child: BlocConsumer<SetPasswordCubit, SetPasswordState>(
        listener: (context, state) async {
          if (state is SetPasswordSuccess) {
            await MySharedPreferences.setName(_fullNameController.text.trim());
            await MySharedPreferences.setId(state.user.id);

            if (context.mounted) {
              CustomSnacbar.show(
                context,
                text: state.message,
              );
              context.push('/pin_code');
            }
          } else if (state is SetPasswordError) {
            CustomSnacbar.show(
              context,
              text: state.message,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SetPasswordLoading;
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.textTheme.titleLarge?.color,
                  size: 24.sp,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // fields_texts:
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),

                          // title:
                          Text(
                            'auth_setup_title'.tr(),
                            style: GoogleFonts.urbanist(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // subtitle:
                          Text(
                            'auth_setup_subtitle'.tr(),
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodySmall?.color,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // full_name_field:
                          CustomTextField(
                            label: 'auth_setup_fullname_label'.tr(),
                            controller: _fullNameController,
                            focusNode: _fullNameFocus,
                            prefixIcon: Icons.person_outline,
                            hintText: 'auth_setup_fullname_hint'.tr(),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_passwordFocus);
                            },
                          ),

                          SizedBox(height: 20.h),

                          // password_field:
                          CustomTextField(
                            label: 'auth_setup_password_label'.tr(),
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            prefixIcon: Icons.lock_outline,
                            hintText: 'auth_setup_password_hint'.tr(),
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: theme.textTheme.bodySmall?.color,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_confirmPasswordFocus);
                            },
                          ),

                          SizedBox(height: 20.h),

                          // confirm_password_field:
                          CustomTextField(
                            label: 'auth_setup_confirm_label'.tr(),
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            prefixIcon: Icons.lock_outline,
                            hintText: 'auth_setup_confirm_hint'.tr(),
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: theme.textTheme.bodySmall?.color,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            onFieldSubmitted: (_) {
                              _onContinue(context);
                            },
                          ),

                          SizedBox(height: 24.h),

                          // security_info:
                          _buildSecurityInfoBox(context),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // continue_button:
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                    child: PressableButton(
                      text: 'auth_setup_button'.tr(),
                      onTap: () => _onContinue(context),
                      backgroundColor: theme.colorScheme.primary,
                      textColor: Colors.white,
                      width: double.infinity,
                      height: 56.h,
                      borderRadius: 12,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      isLoading: isLoading,
                      isDisabled: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSecurityInfoBox(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        spacing: 12.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: theme.colorScheme.primary,
            size: 20.sp,
          ),
          Expanded(
            child: Text(
              'auth_setup_security_info'.tr(),
              style: GoogleFonts.urbanist(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: theme.textTheme.bodySmall?.color,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
