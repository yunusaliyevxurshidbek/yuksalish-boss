import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../theme/profile_theme.dart';
import '../widgets/support/support.dart';

/// Screen for help and support options.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
          'profile_support_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.p8.h),
            const SupportHeaderCard(),
            SizedBox(height: AppSizes.p24.h),
            const SupportContactSection(),
            SizedBox(height: AppSizes.p24.h),
            const SupportFaqSection(),
            SizedBox(height: AppSizes.p24.h),
            const SupportWorkingHours(),
            SizedBox(height: AppSizes.p32.h),
          ],
        ),
      ),
    );
  }
}
