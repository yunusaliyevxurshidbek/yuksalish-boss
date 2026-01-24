import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/project_data.dart';
import '../widgets/projects_list_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int _selectedFilterIndex = 0;

  // Mock data
  final List<ProjectData> _projects = const [
    ProjectData(
      id: '1',
      name: 'Yuksalish Tower',
      location: 'Toshkent, Chilonzor',
      totalUnits: 240,
      soldUnits: 186,
      status: 'Qurilish jarayonida',
      statusType: BadgeType.warning,
      totalValue: 48000000000,
      completionPercent: 65,
    ),
    ProjectData(
      id: '2',
      name: 'Premium Residence',
      location: "Toshkent, Mirzo Ulug'bek",
      totalUnits: 120,
      soldUnits: 98,
      status: 'Sotuvda',
      statusType: BadgeType.success,
      totalValue: 36000000000,
      completionPercent: 85,
    ),
    ProjectData(
      id: '3',
      name: 'City Garden',
      location: 'Toshkent, Sergeli',
      totalUnits: 180,
      soldUnits: 45,
      status: 'Yangi',
      statusType: BadgeType.info,
      totalValue: 27000000000,
      completionPercent: 25,
    ),
    ProjectData(
      id: '4',
      name: 'Green Valley',
      location: 'Toshkent, Yunusobod',
      totalUnits: 96,
      soldUnits: 96,
      status: 'Tugallangan',
      statusType: BadgeType.success,
      totalValue: 19200000000,
      completionPercent: 100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: theme.scaffoldBackgroundColor,
        title: Text(
          'Loyihalar',
          style: AppTextStyles.h3.copyWith(
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.string(
              AppIcons.search,
              width: AppSizes.iconL.w,
              colorFilter: ColorFilter.mode(
                theme.iconTheme.color ?? Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.string(
              AppIcons.filter,
              width: AppSizes.iconL.w,
              colorFilter: ColorFilter.mode(
                theme.iconTheme.color ?? Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: AppSizes.p8.w),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: AppSizes.p16.h),
          FilterChipGroup(
            items: [
              'project_filter_all'.tr(),
              'project_filter_active'.tr(),
              'project_filter_completed'.tr(),
              'project_filter_plan'.tr(),
            ],
            selectedIndex: _selectedFilterIndex,
            horizontalPadding: AppSizes.p16,
            onSelected: (index) {
              setState(() => _selectedFilterIndex = index);
            },
          ),
          SizedBox(height: AppSizes.p16.h),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p16.w,
                vertical: AppSizes.p8.h,
              ),
              itemCount: _projects.length,
              separatorBuilder: (_, __) => SizedBox(height: AppSizes.p12.h),
              itemBuilder: (context, index) {
                final project = _projects[index];
                return ProjectsListCard(
                  project: project,
                  onTap: () {
                    context.push(RouteNames.projectDetailPath(project.id));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
