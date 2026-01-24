import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/core/enums/otp_flow.dart';
import 'package:yuksalish_mobile/core/services/my_shared_preferences.dart';
import 'package:yuksalish_mobile/injection_container.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_event.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_state.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:yuksalish_mobile/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_number_pad.dart';
import 'package:yuksalish_mobile/presentation/widgets/custom_snacbar.dart';
import 'widgets/widgets.dart';

class PinCodePage extends StatefulWidget {
  final bool popOnComplete;

  const PinCodePage({super.key, this.popOnComplete = false});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  bool _biometricTriggered = false;
  bool _biometricDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerBiometricIfNeeded();
    });
  }

  void _triggerBiometricIfNeeded() {
    if (_biometricTriggered) return;

    final bloc = context.read<AppLockBloc>();
    final state = bloc.state;

    if (state.mode == AppLockMode.verify &&
        state.isBiometricEnabled &&
        !state.isLockedOut &&
        !state.biometricPromptShowing) {
      _biometricTriggered = true;
      bloc.add(const AppLockBiometricRequested());
    }
  }

  void _onNumberTap(String number) {
    context.read<AppLockBloc>().add(AppLockPinDigitEntered(number));
  }

  void _onBackspace() {
    context.read<AppLockBloc>().add(const AppLockPinDigitDeleted());
  }

  void _onBiometricTap() {
    context.read<AppLockBloc>().add(const AppLockBiometricRequested());
  }

  Future<void> _onForgotPassword() async {
    final phone = MySharedPreferences.getPhone();
    if (phone == null || phone.isEmpty) {
      if (mounted) {
        CustomSnacbar.show(
          context,
          text: 'auth_pin_phone_not_found'.tr(),
          isError: true,
        );
      }
      return;
    }

    final confirmed = await ResetPinDialog.show(context);
    if (confirmed == true && mounted) {
      _sendOtpForPinReset(phone);
    }
  }

  void _sendOtpForPinReset(String phone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider(
        create: (_) => getIt<ForgotPasswordCubit>(),
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (ctx, state) {
            if (state is ForgotPasswordSuccess) {
              dialogContext.pop();
              CustomSnacbar.show(context, text: state.message);
              context.push('/otp_page', extra: {
                'phone': phone,
                'flow': OtpFlow.resetPin,
              });
            } else if (state is ForgotPasswordError) {
              dialogContext.pop();
              CustomSnacbar.show(context, text: state.message, isError: true);
            }
          },
          builder: (ctx, state) {
            if (state is ForgotPasswordLoading) {
              return const SendingCodeDialog();
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

  Future<void> _showBiometricEnableDialog(AppLockState state) async {
    if (_biometricDialogShown || !state.isBiometricAvailable) {
      if (mounted) context.go('/dashboard');
      return;
    }

    _biometricDialogShown = true;
    final result = await EnableBiometricDialog.show(context);

    if (result == true && mounted) {
      context.read<AppLockBloc>().add(const AppLockToggleBiometric(true));
    }

    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLockBloc, AppLockState>(
      listener: (context, state) {
        if (state.mode == AppLockMode.unlocked && !_biometricDialogShown) {
          if (widget.popOnComplete) {
            // PIN setup/change from Profile - show success message and go back
            CustomSnacbar.show(
              context,
              text: 'auth_pin_changed_success'.tr(),
            );
            context.pop();
          } else if (state.isBiometricAvailable && !state.isBiometricEnabled) {
            _showBiometricEnableDialog(state);
          } else {
            context.go('/dashboard');
          }
        }
      },
      builder: (context, state) {
        final isSetupFlow =
            state.mode == AppLockMode.setup || state.mode == AppLockMode.confirm;
        final isChangeFlow = state.mode == AppLockMode.changeVerify ||
            state.mode == AppLockMode.changeSetup ||
            state.mode == AppLockMode.changeConfirm;
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: (isSetupFlow || isChangeFlow)
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.textTheme.titleLarge?.color,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      if (state.mode == AppLockMode.confirm) {
                        context.read<AppLockBloc>().add(const AppLockStartSetup());
                      } else if (state.mode == AppLockMode.changeConfirm) {
                        context.read<AppLockBloc>().add(const AppLockStartChange());
                      } else if (state.mode == AppLockMode.changeSetup) {
                        context.read<AppLockBloc>().add(const AppLockStartChange());
                      } else {
                        context.pop();
                      }
                    },
                  )
                : const SizedBox.shrink(),
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
                        Text(
                          state.title,
                          style: GoogleFonts.urbanist(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            state.subtitle,
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: state.error != null
                                  ? theme.colorScheme.error
                                  : theme.textTheme.bodySmall?.color,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 48.h),
                        PinIndicators(
                          filledCount: state.currentPin.length,
                          hasError: state.error != null,
                        ),
                        SizedBox(height: 24.h),
                        if (state.mode == AppLockMode.verify)
                          GestureDetector(
                            onTap: _onForgotPassword,
                            child: Text(
                              'auth_pin_forgot'.tr(),
                              style: GoogleFonts.urbanist(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
                // Show biometric toggle during PIN setup (initial or change)
                if (isSetupFlow ||
                    state.mode == AppLockMode.changeSetup ||
                    state.mode == AppLockMode.changeConfirm) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: BiometricToggle(
                      isEnabled: state.isBiometricEnabled,
                      isAvailable: state.isBiometricAvailable,
                      onChanged: (value) {
                        context
                            .read<AppLockBloc>()
                            .add(AppLockToggleBiometric(value));
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
                CustomNumberPad(
                  onNumberTap: state.canEnterDigit ? _onNumberTap : (_) {},
                  onBackspace: state.canDeleteDigit ? _onBackspace : () {},
                  onBiometricTap: _onBiometricTap,
                  showBiometricIcon: state.mode == AppLockMode.verify &&
                      state.isBiometricEnabled &&
                      state.isBiometricAvailable &&
                      !state.isLockedOut,
                  isDisabled: state.isLockedOut || state.isLoading,
                ),
                const SecurityFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}
