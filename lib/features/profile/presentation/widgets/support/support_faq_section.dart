import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../theme/profile_theme.dart';

/// FAQ section for support screen.
class SupportFaqSection extends StatelessWidget {
  const SupportFaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile_support_faq_title'.tr(),
          style: AppTextStyles.labelSmall.copyWith(
            color: colors.textTertiary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: AppSizes.p12.h),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          ),
          child: Column(
            children: [
              _FaqTile(
                question: 'profile_support_faq_q1'.tr(),
                onTap: () => _showFaqAnswer(
                  context,
                  'profile_support_faq_q1_title'.tr(),
                  'profile_support_faq_q1_answer'.tr(),
                ),
              ),
              const _FaqDivider(),
              _FaqTile(
                question: 'profile_support_faq_q2'.tr(),
                onTap: () => _showFaqAnswer(
                  context,
                  'profile_support_faq_q2_title'.tr(),
                  'profile_support_faq_q2_answer'.tr(),
                ),
              ),
              const _FaqDivider(),
              _FaqTile(
                question: 'profile_support_faq_q3'.tr(),
                onTap: () => _showFaqAnswer(
                  context,
                  'profile_support_faq_q3_title'.tr(),
                  'profile_support_faq_q3_answer'.tr(),
                ),
              ),
              const _FaqDivider(),
              _FaqTile(
                question: 'profile_support_faq_q4'.tr(),
                onTap: () => _showFaqAnswer(
                  context,
                  'profile_support_faq_q4_title'.tr(),
                  'profile_support_faq_q4_answer'.tr(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFaqAnswer(BuildContext context, String title, String answer) {
    final colors = ProfileThemeColors.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      builder: (context) => _FaqAnswerSheet(title: title, answer: answer),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final VoidCallback onTap;

  const _FaqTile({required this.question, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p12.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textTertiary,
              size: AppSizes.iconM.w,
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqDivider extends StatelessWidget {
  const _FaqDivider();

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Divider(
      height: 1,
      indent: AppSizes.p16.w,
      endIndent: AppSizes.p16.w,
      color: colors.divider,
    );
  }
}

class _FaqAnswerSheet extends StatelessWidget {
  final String title;
  final String answer;

  const _FaqAnswerSheet({required this.title, required this.answer});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: AppSizes.p24.h),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.p16.h),
            Text(
              answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSizes.p24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.textOnPrimary,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.p12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  ),
                ),
                child: Text('common_got_it'.tr(), style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
