import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/models/models.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../bloc/profile_edit_bloc.dart';
import '../theme/profile_theme.dart';
import '../widgets/profile_details_avatar_section.dart';
import '../widgets/profile_details_business_section.dart';
import '../widgets/profile_details_contact_section.dart';
import '../widgets/profile_details_personal_form.dart';
import 'change_password_dialog.dart';
import 'change_phone_sheet.dart';

/// Screen for editing profile details.
class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileEditBloc(
        repository: context.read(),
      )..add(const LoadProfile()),
      child: const _ProfileDetailsView(),
    );
  }
}

class _ProfileDetailsView extends StatefulWidget {
  const _ProfileDetailsView();

  @override
  State<_ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<_ProfileDetailsView> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserProfile profile) {
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
  }

  void _handleSaveBasicInfo(ProfileEditBloc bloc) {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty) {
      CustomSnacbar.show(
        context,
        text: 'profile_details_fill_all'.tr(),
        isError: true,
      );
      return;
    }

    bloc.add(
      UpdateBasicInfo(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
      ),
    );
  }

  void _showChangePhoneSheet(String currentPhone) {
    final colors = ProfileThemeColors.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => ChangePhoneSheet(currentPhone: currentPhone),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: colors.textOnPrimary,
            size: AppSizes.iconL.w,
          ),
        ),
        title: Text(
          'profile_details_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: colors.textOnPrimary,
          ),
        ),
      ),
      body: BlocListener<ProfileEditBloc, ProfileEditState>(
        listener: (context, state) {
          if (state.formStatus == FormStatus.success && state.profile != null) {
            CustomSnacbar.show(
              context,
              text: 'profile_details_saved'.tr(),
            );
          }

          if (state.formStatus == FormStatus.failure &&
              state.errorMessage != null) {
            CustomSnacbar.show(
              context,
              text: state.errorMessage ?? 'common_error'.tr(),
              isError: true,
            );
          }
        },
        child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
          builder: (context, state) {
            if (state.isLoading && state.profile == null) {
              return Center(
                child: CircularProgressIndicator(color: colors.primary),
              );
            }

            if (state.profile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'common_error'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileEditBloc>().add(const LoadProfile());
                      },
                      child: Text('common_retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            if (_firstNameController.text.isEmpty && state.profile != null) {
              _initializeControllers(state.profile!);
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ProfileDetailsAvatarSection(profile: state.profile!),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ProfileDetailsPersonalForm(
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      emailController: _emailController,
                      state: state,
                      onSave: () =>
                          _handleSaveBasicInfo(context.read<ProfileEditBloc>()),
                    ),
                  ),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 16.h)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ProfileDetailsContactSection(
                      profile: state.profile!,
                      onChangePhone: () =>
                          _showChangePhoneSheet(state.profile!.phone),
                      onChangePassword: _showChangePasswordDialog,
                    ),
                  ),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 16.h)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ProfileDetailsBusinessSection(profile: state.profile!),
                  ),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 24.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}
