import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class OnboardingPageItem extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingPageItem({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            fontSize: 32.sp,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w300,
            fontSize: 18.sp,
            color: AppColors.softGrey,
          ),
        ),
      ],
    );
  }
}
