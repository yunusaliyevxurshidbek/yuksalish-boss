import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final IconData prefixIcon;
  final String hintText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    required this.prefixIcon,
    required this.hintText,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark ? theme.cardColor : AppColors.softGrey;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onFieldSubmitted: onFieldSubmitted,
          style: GoogleFonts.urbanist(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.titleMedium?.color,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.urbanist(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: theme.textTheme.bodySmall?.color,
              size: 20.sp,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: borderColor,
                width: 1,
              ),
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
                width: 1,
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
        ),
      ],
    );
  }
}
