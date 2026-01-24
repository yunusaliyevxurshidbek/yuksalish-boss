import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../theme/profile_theme.dart';

/// Screen for changing PIN code.
class PinChangeScreen extends StatefulWidget {
  const PinChangeScreen({super.key});

  @override
  State<PinChangeScreen> createState() => _PinChangeScreenState();
}

class _PinChangeScreenState extends State<PinChangeScreen> {
  final int _pinLength = 6;
  String _currentPin = '';
  String _newPin = '';
  String _confirmPin = '';
  int _step = 0; // 0: current, 1: new, 2: confirm
  String? _errorMessage;

  String get _title {
    switch (_step) {
      case 0:
        return 'profile_pin_change_step_current'.tr();
      case 1:
        return 'profile_pin_change_step_new'.tr();
      case 2:
        return 'profile_pin_change_step_confirm'.tr();
      default:
        return '';
    }
  }

  String get _currentInput {
    switch (_step) {
      case 0:
        return _currentPin;
      case 1:
        return _newPin;
      case 2:
        return _confirmPin;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colors.textPrimary,
            size: AppSizes.iconL.w,
          ),
        ),
        title: Text(
          'profile_pin_change_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lock Icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: colors.tintIconBackground(colors.primary),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 40.w,
                    color: colors.primary,
                  ),
                ),

                SizedBox(height: AppSizes.p24.h),

                // Title
                Text(
                  _title,
                  style: AppTextStyles.h4.copyWith(
                    color: colors.textPrimary,
                  ),
                ),

                SizedBox(height: AppSizes.p32.h),

                // PIN Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pinLength,
                    (index) => _buildPinDot(index < _currentInput.length),
                  ),
                ),

                SizedBox(height: AppSizes.p16.h),

                // Error Message
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.error,
                    ),
                  ),

                SizedBox(height: AppSizes.p16.h),

                // Forgot PIN
                if (_step == 0)
                  TextButton(
                    onPressed: () {
                      // TODO: Handle forgot PIN
                      CustomSnacbar.show(
                        context,
                        text: 'profile_pin_change_contact_admin'.tr(),
                      );
                    },
                    child: Text(
                      'profile_pin_change_forgot'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Keypad
          _buildKeypad(),

          SizedBox(height: AppSizes.p32.h),
        ],
      ),
    );
  }

  Widget _buildPinDot(bool filled) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      width: 16.w,
      height: 16.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? colors.primary : Colors.transparent,
        border: Border.all(
          color: colors.primary,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p32.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('1'),
              _buildKeypadButton('2'),
              _buildKeypadButton('3'),
            ],
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('4'),
              _buildKeypadButton('5'),
              _buildKeypadButton('6'),
            ],
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('7'),
              _buildKeypadButton('8'),
              _buildKeypadButton('9'),
            ],
          ),
          SizedBox(height: AppSizes.p16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('', isEmpty: true),
              _buildKeypadButton('0'),
              _buildKeypadButton('backspace', isBackspace: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(
    String value, {
    bool isEmpty = false,
    bool isBackspace = false,
  }) {
    final colors = ProfileThemeColors.of(context);
    if (isEmpty) {
      return SizedBox(width: 72.w, height: 72.w);
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (isBackspace) {
          _onBackspace();
        } else {
          _onKeyPress(value);
        }
      },
      child: Container(
        width: 72.w,
        height: 72.w,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          boxShadow: [colors.cardShadow],
        ),
        child: Center(
          child: isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  color: colors.textPrimary,
                  size: AppSizes.iconL.w,
                )
              : Text(
                  value,
                  style: AppTextStyles.h3.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }

  void _onKeyPress(String value) {
    setState(() {
      _errorMessage = null;

      switch (_step) {
        case 0:
          if (_currentPin.length < _pinLength) {
            _currentPin += value;
            if (_currentPin.length == _pinLength) {
              _verifyCurrentPin();
            }
          }
          break;
        case 1:
          if (_newPin.length < _pinLength) {
            _newPin += value;
            if (_newPin.length == _pinLength) {
              _step = 2;
            }
          }
          break;
        case 2:
          if (_confirmPin.length < _pinLength) {
            _confirmPin += value;
            if (_confirmPin.length == _pinLength) {
              _verifyNewPin();
            }
          }
          break;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      _errorMessage = null;

      switch (_step) {
        case 0:
          if (_currentPin.isNotEmpty) {
            _currentPin = _currentPin.substring(0, _currentPin.length - 1);
          }
          break;
        case 1:
          if (_newPin.isNotEmpty) {
            _newPin = _newPin.substring(0, _newPin.length - 1);
          }
          break;
        case 2:
          if (_confirmPin.isNotEmpty) {
            _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
          }
          break;
      }
    });
  }

  void _verifyCurrentPin() {
    // TODO: Verify current PIN with AppLockBloc
    // For now, accept any PIN
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _step = 1;
      });
    });
  }

  void _verifyNewPin() {
    if (_newPin == _confirmPin) {
      // TODO: Save new PIN with AppLockBloc
      CustomSnacbar.show(
        context,
        text: 'profile_pin_change_success'.tr(),
      );
      context.pop();
    } else {
      setState(() {
        _errorMessage = 'profile_pin_change_mismatch'.tr();
        _confirmPin = '';
      });
      HapticFeedback.heavyImpact();
    }
  }
}
