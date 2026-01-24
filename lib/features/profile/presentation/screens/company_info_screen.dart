import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../theme/profile_theme.dart';

/// Screen showing company information.
class CompanyInfoScreen extends StatelessWidget {
  const CompanyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: Scaffold(
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
            'profile_company_title'.tr(),
            style: AppTextStyles.h3.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final company = state.profile?.company;

            if (company == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: colors.primary,
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Column(
                children: [
                  SizedBox(height: AppSizes.p16.h),

                  // Company Logo
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: colors.tintIconBackground(colors.primary),
                      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: company.logoUrl != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusL.r - 2),
                            child: Image.network(
                              company.logoUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.business_rounded,
                            size: 60.w,
                            color: colors.primary,
                          ),
                  ),

                  SizedBox(height: AppSizes.p24.h),

                  // Company Name
                  Text(
                    company.name,
                    style: AppTextStyles.h2.copyWith(
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSizes.p32.h),

                  // Info Cards
                  _buildInfoCard(
                    context: context,
                    icon: Icons.badge_outlined,
                    title: 'profile_company_id_label'.tr(),
                    value: company.id,
                  ),

                  SizedBox(height: AppSizes.p12.h),

                  _buildInfoCard(
                    context: context,
                    icon: Icons.location_city_outlined,
                    title: 'profile_company_name_label'.tr(),
                    value: company.name,
                  ),

                  SizedBox(height: AppSizes.p12.h),

                  _buildInfoCard(
                    context: context,
                    icon: Icons.person_outline_rounded,
                    title: 'profile_company_role_label'.tr(),
                    value: state.profile?.role ?? 'common_unknown'.tr(),
                  ),

                  SizedBox(height: AppSizes.p32.h),

                  // Note
                  Container(
                    padding: EdgeInsets.all(AppSizes.p16.w),
                    decoration: BoxDecoration(
                      color: colors.infoLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                      border: Border.all(
                        color: colors.info.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: colors.info,
                          size: AppSizes.iconM.w,
                        ),
                        SizedBox(width: AppSizes.p12.w),
                        Expanded(
                          child: Text(
                            'profile_company_note'.tr(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    final colors = ProfileThemeColors.of(context);
    return Container(
      padding: EdgeInsets.all(AppSizes.p16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        boxShadow: [colors.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: colors.tintIconBackground(colors.primary),
              borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
            ),
            child: Icon(
              icon,
              color: colors.primary,
              size: AppSizes.iconM.w,
            ),
          ),
          SizedBox(width: AppSizes.p12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
