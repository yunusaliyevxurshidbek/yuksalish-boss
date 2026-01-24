import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection_container.dart';
import '../../../../presentation/widgets/custom_snacbar.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../theme/profile_theme.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_save_button.dart';
import '../widgets/profile_text_field.dart';

/// Screen for editing user profile information.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();

    // Load profile data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<ProfileCubit>().loadProfile();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initControllers(ProfileState state) {
    if (state.profile != null && _firstNameController.text.isEmpty) {
      _firstNameController.text = state.profile!.firstName;
      _lastNameController.text = state.profile!.lastName;
      _phoneController.text = state.profile!.phone;
      _emailController.text = state.profile!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) => _initControllers(state),
        builder: (context, state) {
          final colors = ProfileThemeColors.of(context);
          _initControllers(state);

          // Show loading indicator while profile is loading
          if (state.isLoading && state.profile == null) {
            return Scaffold(
              backgroundColor: colors.background,
              appBar: _buildAppBar(context),
              body: Center(
                child: CircularProgressIndicator(
                  color: colors.primary,
                ),
              ),
            );
          }

          // Show error state
          if (state.hasError && state.profile == null) {
            return Scaffold(
              backgroundColor: colors.background,
              appBar: _buildAppBar(context),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'common_error'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    if (state.errorMessage != null)
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Text(
                          state.errorMessage!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => getIt<ProfileCubit>().loadProfile(),
                      child: Text('common_retry'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: colors.background,
            appBar: _buildAppBar(context),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.p16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: AppSizes.p16.h),
                    _buildAvatarSection(state),
                    SizedBox(height: AppSizes.p24.h),
                    _buildFormFields(state),
                    SizedBox(height: AppSizes.p32.h),
                    ProfileSaveButton(
                      onPressed: _saveProfile,
                      isLoading: state.isUpdating,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colors = ProfileThemeColors.of(context);
    return AppBar(
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
        'profile_edit_title'.tr(),
        style: AppTextStyles.h3.copyWith(color: colors.textPrimary),
      ),
    );
  }

  Widget _buildAvatarSection(ProfileState state) {
    return Center(
      child: ProfileAvatar(
        imageUrl: state.profile?.avatarUrl,
        initials: state.profile?.initials ?? 'JA',
        size: 100,
        showCameraButton: false,
      ),
    );
  }

  Widget _buildFormFields(ProfileState state) {
    final colors = ProfileThemeColors.of(context);
    return Column(
      children: [
        ProfileTextField(
          label: 'profile_edit_first_name_label'.tr(),
          controller: _firstNameController,
          validator: (value) =>
              value?.isEmpty ?? true
                  ? 'profile_edit_first_name_required'.tr()
                  : null,
        ),
        SizedBox(height: AppSizes.p16.h),
        ProfileTextField(
          label: 'profile_edit_last_name_label'.tr(),
          controller: _lastNameController,
          validator: (value) =>
              value?.isEmpty ?? true
                  ? 'profile_edit_last_name_required'.tr()
                  : null,
        ),
        SizedBox(height: AppSizes.p16.h),
        ProfileTextField(
          label: 'profile_edit_phone_label'.tr(),
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) =>
              value?.isEmpty ?? true
                  ? 'profile_edit_phone_required'.tr()
                  : null,
        ),
        SizedBox(height: AppSizes.p16.h),
        ProfileTextField(
          label: 'profile_edit_email_label'.tr(),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'profile_edit_email_required'.tr();
            }
            if (!value!.contains('@')) {
              return 'profile_edit_email_invalid'.tr();
            }
            return null;
          },
        ),
        SizedBox(height: AppSizes.p16.h),
        ProfileTextField(
          label: 'profile_edit_role_label'.tr(),
          controller: TextEditingController(text: state.profile?.role ?? ''),
          enabled: false,
          suffixIcon: Icon(
            Icons.lock_outline_rounded,
            color: colors.textTertiary,
            size: AppSizes.iconS.w,
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<ProfileCubit>();
      final currentProfile = cubit.state.profile;

      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
        );

        final success = await cubit.updateProfile(updatedProfile);

        if (mounted) {
          if (success) {
            CustomSnacbar.show(
              context,
              text: 'profile_edit_saved'.tr(),
            );
            context.pop();
          } else {
            final errorMessage =
                cubit.state.errorMessage ?? 'common_error'.tr();
            CustomSnacbar.show(
              context,
              text: errorMessage,
              isError: true,
            );
          }
        }
      }
    }
  }
}
