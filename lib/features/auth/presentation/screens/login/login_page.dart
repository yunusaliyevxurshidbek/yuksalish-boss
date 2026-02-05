import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInput;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/theme/app_theme.dart';
import 'package:yuksalish_mobile/injection_container.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/login/login_cubit.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/login/login_state.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_button_universal.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_snacbar.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  String _fullPhoneNumber = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    final phone = _fullPhoneNumber.trim();
    final password = _passwordController.text.trim();
    if (phone.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'auth_login_phone_required'.tr(),
        isError: true,
      );
      return;
    }
    if (password.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'auth_login_password_required'.tr(),
        isError: true,
      );
      return;
    }
    context.read<LoginCubit>().login(phone: phone, password: password);
  }

  void _onForgotPassword() => context.push('/forgot_password');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Notify the OS that autofill is complete so the system
            // prompts the user to save credentials (Google Autofill /
            // iCloud Keychain).
            TextInput.finishAutofillContext();
            CustomSnacbar.show(
              context,
              text: 'auth_login_success'.tr(),
            );
            if (context.mounted) {
              context.go('/pin_code');
            }
          } else if (state is LoginError) {
            CustomSnacbar.show(
              context,
              text: state.message,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: context.canPop()
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.textTheme.titleLarge?.color,
                        size: 24.sp,
                      ),
                      onPressed: () => context.pop(),
                    )
                  : null,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),

                          // title:
                          Text(
                            'auth_login_title'.tr(),
                            style: GoogleFonts.urbanist(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // subtitle:
                          Text(
                            'auth_login_subtitle'.tr(),
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: theme.textTheme.bodySmall?.color,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // AutofillGroup groups phone & password so the OS
                          // password manager can suggest saved credentials.
                          AutofillGroup(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // phone_number_label:
                                Text(
                                  'auth_login_phone_label'.tr(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.textTheme.titleMedium?.color,
                                    letterSpacing: 1.2,
                                  ),
                                ),

                                SizedBox(height: 12.h),

                                // phone_number_field:
                                _buildPhoneField(context),

                                SizedBox(height: 20.h),

                                // password_field:
                                CustomTextField(
                                  label: 'auth_login_password_label'.tr(),
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  prefixIcon: Icons.lock_outline,
                                  hintText: 'auth_login_password_hint'.tr(),
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
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
                                    _onLogin(context);
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // forgot_password:
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _onForgotPassword,
                              child: Text(
                                'auth_login_forgot_password'.tr(),
                                style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // login_button:
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                    child: PressableButton(
                      text: 'auth_login_button'.tr(),
                      onTap: () => _onLogin(context),
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

  Widget _buildPhoneField(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark ? theme.cardColor : AppColors.softGrey;
    final borderColor = isDark ? AppColors.darkBorder : Colors.transparent;

    return IntlPhoneField(
      controller: _phoneController,
      decoration: InputDecoration(
        hintText: '90 123 45 67',
        hintStyle: GoogleFonts.urbanist(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
      ),
      initialCountryCode: 'UZ',
      style: GoogleFonts.urbanist(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: theme.textTheme.titleMedium?.color,
      ),
      dropdownTextStyle: GoogleFonts.urbanist(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: theme.textTheme.titleMedium?.color,
      ),
      flagsButtonPadding: EdgeInsets.only(left: 12.w),
      showCountryFlag: true,
      showDropdownIcon: true,
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: theme.textTheme.titleMedium?.color,
        size: 24.sp,
      ),
      onChanged: (phone) {
        _fullPhoneNumber = phone.completeNumber;
      },
    );
  }
}
