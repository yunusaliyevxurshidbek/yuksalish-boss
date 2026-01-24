import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../data/models/models.dart';
import 'project_detail_hero_section.dart';

/// Sliver app bar for project detail screen.
class ProjectDetailAppBar extends StatelessWidget {
  final Project project;
  final bool innerBoxIsScrolled;
  final TabController tabController;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMorePressed;

  const ProjectDetailAppBar({
    super.key,
    required this.project,
    required this.innerBoxIsScrolled,
    required this.tabController,
    this.onBackPressed,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      backgroundColor: theme.cardColor,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: onBackPressed ?? () => context.pop(),
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(51),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: AppSizes.iconM.w,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onMorePressed,
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: AppSizes.iconM.w,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ProjectDetailHeroSection(project: project),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(48.h),
        child: Container(
          color: theme.cardColor,
          child: TabBar(
            controller: tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.textTheme.bodySmall?.color,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            labelStyle: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: AppTextStyles.labelMedium,
            tabs: [
              Tab(text: 'projects_tab_overview'.tr()),
              Tab(text: 'projects_tab_apartments'.tr()),
              Tab(text: 'projects_tab_finance'.tr()),
            ],
          ),
        ),
      ),
    );
  }
}
