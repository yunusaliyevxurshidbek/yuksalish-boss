import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/enums/otp_flow.dart';
import 'package:yuksalish_mobile/injection_container.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_event.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/otp/verify_otp_cubit.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/otp/verify_otp_state.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_number_pad.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_snacbar.dart';

import 'widgets/widgets.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final OtpFlow flow;

  const OtpPage({
    super.key,
    this.phoneNumber = '+998 90 123 45 67',
    this.name = '',
    this.flow = OtpFlow.forgotPassword,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _canResend = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _onResendCode() {
    if (!_canResend) return;

    final phone = widget.phoneNumber.replaceAll(RegExp(r'\s+'), '');
    _resendForgotPasswordOtp(phone);
  }

  void _resendForgotPasswordOtp(String phone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider(
        create: (_) => getIt<ForgotPasswordCubit>(),
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (ctx, state) {
            if (state is ForgotPasswordSuccess) {
              dialogContext.pop();
              _pinController.clear();
              _startTimer();
              CustomSnacbar.show(context, text: state.message);
            } else if (state is ForgotPasswordError) {
              dialogContext.pop();
              CustomSnacbar.show(context, text: state.message, isError: true);
            }
          },
          builder: (ctx, state) {
            if (state is ForgotPasswordLoading) {
              return const OtpLoadingDialog();
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ctx.read<ForgotPasswordCubit>().sendCode(phone: phone);
            });
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _onNumberTap(String number) {
    if (_pinController.text.length < 6) {
      _pinController.text += number;
    }
  }

  void _onBackspace() {
    if (_pinController.text.isNotEmpty) {
      _pinController.text = _pinController.text.substring(
        0,
        _pinController.text.length - 1,
      );
    }
  }

  void _onCompleted(BuildContext context, String pin) {
    final phone = widget.phoneNumber.replaceAll(RegExp(r'\s+'), '');

    if (widget.flow == OtpFlow.forgotPassword) {
      context.push('/reset_password', extra: {'phone': phone, 'code': pin});
      return;
    }

    if (context.read<VerifyOtpCubit>().state is VerifyOtpLoading) {
      return;
    }
    final trimmedName = widget.name.trim();
    final name = trimmedName.isEmpty ? 'User' : trimmedName;
    context.read<VerifyOtpCubit>().submit(phone: phone, code: pin, name: name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VerifyOtpCubit>(),
      child: BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
        listener: (context, state) {
          if (state is VerifyOtpSuccess) {
            CustomSnacbar.show(context, text: state.message);
            if (context.mounted) {
              if (widget.flow == OtpFlow.resetPin) {
                getIt<AppLockBloc>().add(const AppLockReset());
                context.go('/pin_code');
              } else if (state.needsPassword) {
                context.push('/setup_user_info', extra: {
                  'phone': widget.phoneNumber.replaceAll(RegExp(r'\s+'), ''),
                  'name': widget.name,
                });
              } else {
                context.push('/pin_code');
              }
            }
          } else if (state is VerifyOtpError) {
            CustomSnacbar.show(context, text: state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state is VerifyOtpLoading;
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
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          const OtpSecurityIcon(),
                          SizedBox(height: 32.h),
                          Text(
                            'auth_otp_title'.tr(),
                            style: GoogleFonts.urbanist(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          OtpSubtitle(phoneNumber: widget.phoneNumber),
                          SizedBox(height: 40.h),
                          OtpPinInput(
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            onCompleted: (pin) => _onCompleted(context, pin),
                          ),
                          if (isLoading) ...[
                            SizedBox(height: 24.h),
                            SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                          SizedBox(height: 32.h),
                          OtpResendSection(
                            canResend: _canResend,
                            remainingSeconds: _remainingSeconds,
                            onResend: _onResendCode,
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: isLoading,
                    child: CustomNumberPad(
                      onNumberTap: _onNumberTap,
                      onBackspace: _onBackspace,
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
}
