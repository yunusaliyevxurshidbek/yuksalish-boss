import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/localization/bloc/language_bloc.dart';
import '../../../../injection_container.dart';
import '../../../../presentation/widgets/custom_button_universal.dart';
import '../bloc/profile_cubit.dart';
import '../theme/profile_theme.dart';

/// Screen for selecting app language.
class LanguageScreen extends StatelessWidget {
  /// Whether to show the "Continue" button.
  /// Set to true when navigating from splash screen.
  final bool showContinueButton;

  const LanguageScreen({
    super.key,
    this.showContinueButton = false,
  });

  static const List<_LanguageOption> _languages = [
    _LanguageOption(
      code: 'uz',
      nameKey: 'language_uz_name',
      nativeNameKey: 'language_uz_native',
      flag: '🇺🇿',
    ),
    _LanguageOption(
      code: 'ru',
      nameKey: 'language_ru_name',
      nativeNameKey: 'language_ru_native',
      flag: '🇷🇺',
    ),
    _LanguageOption(
      code: 'en',
      nameKey: 'language_en_name',
      nativeNameKey: 'language_en_native',
      flag: '🇬🇧',
    ),
  ];

  void _onLanguageSelected(BuildContext context, String code, String current) {
    if (code == current) return;
    context.read<LanguageBloc>().add(LanguageChanged(code));
    getIt<ProfileCubit>().setLanguage(_toProfileLanguageCode(code));
  }

  void _onContinue(BuildContext context) {
    context.go('/login_page');
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
          'profile_language_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          final selectedLanguage = state.localeCode;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSizes.p16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                      border: Border.all(
                        color: colors.border,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: _languages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final language = entry.value;
                        final isSelected = selectedLanguage == language.code;
                        final isLast = index == _languages.length - 1;

                        return Column(
                          children: [
                            _LanguageOptionTile(
                              language: language,
                              isSelected: isSelected,
                              onTap: () => _onLanguageSelected(
                                context,
                                language.code,
                                selectedLanguage,
                              ),
                            ),
                            if (!isLast)
                              Divider(
                                height: 1,
                                indent: AppSizes.p16.w + 56.w,
                                endIndent: AppSizes.p16.w,
                                color: colors.divider,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // Continue Button (only shown when coming from splash)
              if (showContinueButton)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.p16.w,
                    AppSizes.p8.h,
                    AppSizes.p16.w,
                    AppSizes.p24.h,
                  ),
                  child: PressableButton(
                    text: 'profile_language_continue'.tr(),
                    onTap: () => _onContinue(context),
                    backgroundColor: colors.primary,
                    textColor: colors.textOnPrimary,
                    width: double.infinity,
                    height: 56.h,
                    borderRadius: AppSizes.radiusL.r,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

String _toProfileLanguageCode(String localeCode) {
  switch (localeCode) {
    case 'uz':
      return 'uz_latin';
    case 'ru':
    case 'en':
      return localeCode;
    default:
      return 'uz_latin';
  }
}

class _LanguageOption {
  final String code;
  final String nameKey;
  final String nativeNameKey;
  final String flag;

  const _LanguageOption({
    required this.code,
    required this.nameKey,
    required this.nativeNameKey,
    required this.flag,
  });
}

class _LanguageOptionTile extends StatelessWidget {
  final _LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p16.w,
            vertical: AppSizes.p16.h,
          ),
          child: Row(
            children: [
              // Flag
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
                child: Center(
                  child: Text(
                    language.flag,
                    style: TextStyle(fontSize: 28.sp),
                  ),
                ),
              ),

              SizedBox(width: AppSizes.p16.w),

              // Language Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.nameKey.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      language.nativeNameKey.tr(),
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Checkmark
              if (isSelected)
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: colors.textOnPrimary,
                    size: 18.w,
                  ),
                )
              else
                SizedBox(width: 28.w),
            ],
          ),
        ),
      ),
    );
  }
}
