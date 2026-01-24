import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../bloc/bloc.dart';
import '../widgets/project_detail_new/project_detail_new.dart';

/// Project detail screen with tabs.
class ProjectDetailScreenNew extends StatelessWidget {
  final String projectId;

  const ProjectDetailScreenNew({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    final id = int.tryParse(projectId) ?? 0;
    return BlocProvider(
      create: (context) => GetIt.I<ProjectsBloc>()
        ..add(LoadProjectDetail(id)),
      child: const _ProjectDetailContent(),
    );
  }
}

class _ProjectDetailContent extends StatefulWidget {
  const _ProjectDetailContent();

  @override
  State<_ProjectDetailContent> createState() => _ProjectDetailContentState();
}

class _ProjectDetailContentState extends State<_ProjectDetailContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state.isLoading || state.selectedProject == null) {
          return const ProjectDetailLoadingState();
        }

        final project = state.selectedProject!;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                ProjectDetailAppBar(
                  project: project,
                  innerBoxIsScrolled: innerBoxIsScrolled,
                  tabController: _tabController,
                  onBackPressed: () => context.pop(),
                  onMorePressed: () {},
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                ProjectDetailOverviewTab(project: project),
                const ProjectDetailApartmentsTab(),
                ProjectDetailFinanceTab(stats: state.projectStats),
              ],
            ),
          ),
        );
      },
    );
  }
}
