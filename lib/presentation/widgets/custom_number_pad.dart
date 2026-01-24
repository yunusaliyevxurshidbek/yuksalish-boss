import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomNumberPad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometricTap;
  final bool showBiometricIcon;
  final bool isDisabled;

  const CustomNumberPad({
    super.key,
    required this.onNumberTap,
    required this.onBackspace,
    this.onBiometricTap,
    this.showBiometricIcon = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface;
    final disabledColor = baseColor.withValues(alpha: 0.3);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          _buildKeyboardRow(['1', '2', '3'], baseColor, disabledColor),
          SizedBox(height: 16.h),
          _buildKeyboardRow(['4', '5', '6'], baseColor, disabledColor),
          SizedBox(height: 16.h),
          _buildKeyboardRow(['7', '8', '9'], baseColor, disabledColor),
          SizedBox(height: 16.h),
          _buildKeyboardRow([
            showBiometricIcon ? 'biometric' : '',
            '0',
            'backspace',
          ], baseColor, disabledColor),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(
    List<String> keys,
    Color baseColor,
    Color disabledColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys
          .map((key) => _buildKeyboardButton(key, baseColor, disabledColor))
          .toList(),
    );
  }

  Widget _buildKeyboardButton(
    String key,
    Color baseColor,
    Color disabledColor,
  ) {
    if (key.isEmpty) {
      return Expanded(child: Container());
    }

    final color = isDisabled ? disabledColor : baseColor;

    return Expanded(
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () {
                if (key == 'backspace') {
                  onBackspace();
                } else if (key == 'biometric') {
                  onBiometricTap?.call();
                } else {
                  onNumberTap(key);
                }
              },
        child: Container(
          height: 56.h,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: _buildKeyContent(key, color),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyContent(String key, Color color) {
    if (key == 'backspace') {
      return Icon(
        Icons.backspace_outlined,
        size: 28.sp,
        color: color,
      );
    } else if (key == 'biometric') {
      return Icon(
        Icons.fingerprint,
        size: 32.sp,
        color: color,
      );
    } else {
      return Text(
        key,
        style: GoogleFonts.urbanist(
          fontSize: 28.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      );
    }
  }
}
