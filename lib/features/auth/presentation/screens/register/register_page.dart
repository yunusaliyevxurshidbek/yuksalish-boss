import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/constants/app_colors.dart';
import 'package:yuksalish_mobile/core/enums/otp_flow.dart';
import 'package:yuksalish_mobile/injection_container.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/register/register_cubit.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/register/register_state.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_button_universal.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_phone_field.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_snacbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _fullPhoneNumber = '';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue(BuildContext context) {
    final phone = _fullPhoneNumber.trim();
    if (phone.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'auth_register_phone_required'.tr(),
        isError: true,
      );
      return;
    }
    context.read<RegisterCubit>().submit(phone: phone);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            CustomSnacbar.show(context, text: state.message);
            if (context.mounted) {
              context.push('/otp_page', extra: {
                'phone': state.phone,
                'flow': OtpFlow.register,
              });
            }
          } else if (state is RegisterPhoneExists) {
            CustomSnacbar.show(
              context,
              text: 'auth_register_phone_exists'.tr(),
              isError: true,
            );
            if (context.mounted) {
              context.go('/login_page');
            }
          } else if (state is RegisterError) {
            CustomSnacbar.show(
              context,
              text: state.message,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RegisterLoading;
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Curved navy header
                  _buildHeader(context),

                  // Body
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),

                          // Title
                          Text(
                            'auth_register_title'.tr(),
                            style: GoogleFonts.montserrat(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Subtitle
                          Text(
                            'auth_register_subtitle'.tr(),
                            style: GoogleFonts.urbanist(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey500,
                            ),
                          ),

                          SizedBox(height: 32.h),

                          // Phone number label
                          Text(
                            'auth_register_phone_label'.tr(),
                            style: GoogleFonts.montserrat(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.titleMedium?.color,
                              letterSpacing: 1.2,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Phone field
                          CustomPhoneField(
                            controller: _phoneController,
                            onChanged: (phone) {
                              _fullPhoneNumber = phone.completeNumber;
                            },
                          ),

                          SizedBox(height: 32.h),

                          // Continue button
                          PressableButton(
                            text: 'auth_register_button'.tr(),
                            onTap: () => _onContinue(context),
                            backgroundColor: AppColors.primaryNavy,
                            textColor: Colors.white,
                            width: double.infinity,
                            height: 56.h,
                            borderRadius: 12,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            isLoading: isLoading,
                            isDisabled: isLoading,
                          ),

                          SizedBox(height: 24.h),

                          // Already have an account? Login
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'auth_register_already_have_account'.tr(),
                                style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey700,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'auth_register_login_link'.tr(),
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNavy,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => context.go('/login_page'),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // Bottom terms and privacy
                  _buildBottomTerms(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.h,
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.r),
          bottomRight: Radius.circular(50.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Back arrow
            Positioned(
              top: 8.h,
              left: 8.w,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24.sp,
                ),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/login_page');
                  }
                },
              ),
            ),
            // Centered logo
            Center(
              child: Image.asset(
                'assets/images/logo_for_dark.png',
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTerms(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'auth_register_terms_prefix'.tr(),
            style: GoogleFonts.urbanist(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey500,
            ),
            children: [
              TextSpan(
                text: 'auth_register_terms_of_service'.tr(),
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryNavy,
                ),
              ),
              TextSpan(
                text: 'auth_register_and'.tr(),
              ),
              TextSpan(
                text: 'auth_register_privacy_policy'.tr(),
                style: GoogleFonts.urbanist(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
