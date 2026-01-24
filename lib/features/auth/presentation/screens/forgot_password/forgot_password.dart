import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/enums/otp_flow.dart';
import 'package:yuksalish_mobile/injection_container.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_button_universal.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_phone_field.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_snacbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendCode(BuildContext context) {
    final phone = '+998${_phoneController.text.replaceAll(RegExp(r'\s+'), '')}';
    if (_phoneController.text.replaceAll(RegExp(r'\s+'), '').length < 9) {
      CustomSnacbar.show(
        context,
        text: 'auth_forgot_invalid_phone'.tr(),
        isError: true,
      );
      return;
    }
    context.read<ForgotPasswordCubit>().sendCode(phone: phone);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            CustomSnacbar.show(
              context,
              text: state.message,
            );
            if (context.mounted) {
              context.push('/otp_page', extra: {
                'phone': state.phone,
                'flow': OtpFlow.forgotPassword,
              });
            }
          } else if (state is ForgotPasswordError) {
            CustomSnacbar.show(
              context,
              text: state.message,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;
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
                        Text(
                          'auth_forgot_title'.tr(),
                          style: GoogleFonts.urbanist(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'auth_forgot_subtitle'.tr(),
                          style: GoogleFonts.urbanist(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.textTheme.bodySmall?.color,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'auth_forgot_phone_label'.tr(),
                          style: GoogleFonts.urbanist(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.titleMedium?.color,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        CustomPhoneField(
                          controller: _phoneController,
                          onChanged: (phone) {},
                        ),
                        SizedBox(height: 32.h),
                        PressableButton(
                          text: isLoading ? 'auth_forgot_sending'.tr() : 'auth_forgot_send_code'.tr(),
                          onTap: isLoading ? null : () => _onSendCode(context),
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
