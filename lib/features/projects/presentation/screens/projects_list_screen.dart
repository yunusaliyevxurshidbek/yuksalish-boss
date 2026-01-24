import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/repositories/projects_repository.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

/// Projects list screen with filtering and BLoC state management.
class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProjectsBloc>()
        ..add(const LoadProjects()),
      child: const _ProjectsListContent(),
    );
  }
}

class _ProjectsListContent extends StatelessWidget {
  const _ProjectsListContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'project_title'.tr(),
          style: AppTextStyles.h3,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement search
            },
            icon: SvgPicture.string(
              AppIcons.search,
              width: AppSizes.iconL.w,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement filter dialog
            },
            icon: SvgPicture.string(
              AppIcons.filter,
              width: AppSizes.iconL.w,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: AppSizes.p8.w),
        ],
      ),
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProjectsBloc>().add(const RefreshProjects());
              await Future.delayed(const Duration(milliseconds: 1500));
            },
            color: AppColors.primary,
            child: Column(
              children: [
                SizedBox(height: AppSizes.p16.h),
                _buildFilterChips(context, state),
                SizedBox(height: AppSizes.p12.h),
                _buildStatsSummary(state),
                SizedBox(height: AppSizes.p8.h),
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, ProjectsState state) {
    final filters = ProjectFilter.values;
    final selectedIndex = filters.indexOf(state.currentFilter);

    return FilterChipGroup(
      items: filters.map((f) => f.displayName).toList(),
      selectedIndex: selectedIndex,
      horizontalPadding: AppSizes.p16,
      onSelected: (index) {
        context.read<ProjectsBloc>().add(ChangeFilter(filters[index]));
      },
    );
  }

  Widget _buildStatsSummary(ProjectsState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16.w,
          vertical: AppSizes.p12.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              label: 'projects_units_total'.tr(),
              value: state.totalCount.toString(),
              color: AppColors.textPrimary,
            ),
            Container(
              width: 1,
              height: 24.h,
              color: AppColors.divider,
            ),
            _buildStatItem(
              label: 'Faol',
              value: state.activeCount.toString(),
              color: AppColors.success,
            ),
            Container(
              width: 1,
              height: 24.h,
              color: AppColors.divider,
            ),
            _buildStatItem(
              label: 'Tugallangan',
              value: state.completedCount.toString(),
              color: AppColors.info,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h4.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ProjectsState state) {
    if (state.isLoading) {
      return _buildLoadingState();
    }

    if (state.error != null) {
      return _buildErrorState(context, state.error!);
    }

    if (state.projects.isEmpty) {
      return _buildEmptyState();
    }

    // Bottom padding: navbar (70) + margin (12) + safe area (~34) + buffer
    return ListView.builder(
      padding: EdgeInsets.only(
        left: AppSizes.p16.w,
        right: AppSizes.p16.w,
        top: AppSizes.p8.h,
        bottom: 130.h,
      ),
      itemCount: state.projects.length,
      itemBuilder: (context, index) {
        final project = state.projects[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.p16.h),
          child: ProjectCard(
            project: project,
            onTap: () {
              context.push(RouteNames.projectDetailPath(project.id.toString()));
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: AppSizes.p16.w,
        right: AppSizes.p16.w,
        top: AppSizes.p8.h,
        bottom: 130.h,
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.p16.h),
          child: AppShimmer(
            child: Container(
              height: 240.h,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.w,
              color: AppColors.error,
            ),
            SizedBox(height: AppSizes.p16.h),
            Text(
              'Xatolik yuz berdi',
              style: AppTextStyles.h4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.p8.h),
            Text(
              error,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.p24.h),
            ElevatedButton(
              onPressed: () {
                context.read<ProjectsBloc>().add(const RefreshProjects());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: Text('common_retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState.noData(
      title: 'Loyihalar topilmadi',
      description: "Hozircha bu kategoriyada loyihalar yo'q",
    );
  }
}
