import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../data/models/models.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../widgets/apartment_grid_card.dart';
import '../widgets/apartment_list_row.dart';
import '../widgets/apartments_section_header.dart';
import '../widgets/builder_history_section.dart';
import '../widgets/project_carousel.dart';
import '../widgets/projects_app_bar.dart';
import '../widgets/projects_empty_state.dart';
import '../widgets/projects_error_state.dart';
import '../widgets/projects_filter_chips.dart';
import '../widgets/projects_loading_state.dart';
import '../widgets/projects_map_placeholder.dart';
import '../widgets/projects_pagination_info.dart';
import '../widgets/projects_search_sheet.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProjectsBloc>()..add(const LoadProjects()),
      child: const _ProjectsPageContent(),
    );
  }
}

class _ProjectsPageContent extends StatefulWidget {
  const _ProjectsPageContent();

  @override
  State<_ProjectsPageContent> createState() => _ProjectsPageContentState();
}

class _ProjectsPageContentState extends State<_ProjectsPageContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProjectsBloc>().add(const LoadMoreApartments());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _onRefresh() async {
    context.read<ProjectsBloc>().add(const RefreshProjects());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ProjectsAppBar(onSearchTap: () => _showSearchSheet(context)),
      body: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          if (state.status == ProjectsStatus.loading && state.projects.isEmpty) {
            return const ProjectsLoadingState();
          }

          if (state.status == ProjectsStatus.error && state.projects.isEmpty) {
            return ProjectsErrorState(
              error: state.error ?? 'Xatolik yuz berdi',
              onRetry: () {
                context.read<ProjectsBloc>().add(const LoadProjects());
              },
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: theme.colorScheme.primary,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Filter chips
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      ProjectsFilterChips(
                        state: state,
                        onFilterChanged: (filter) {
                          context.read<ProjectsBloc>().add(ChangeFilter(filter));
                        },
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),

                // Projects Carousel
                SliverToBoxAdapter(
                  child: state.isLoading
                      ? const ProjectCarouselSkeleton()
                      : ProjectCarousel(
                          projects: state.projects,
                          selectedProjectId: state.selectedProjectId,
                          onProjectSelected: (projectId) {
                            context.read<ProjectsBloc>().add(SelectProject(projectId));
                          },
                        ),
                ),

                // Apartments Section Header
                if (state.selectedProject != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 24.h),
                          ApartmentsSectionHeader(
                            projectName: state.selectedProject!.name,
                            apartmentsCount: state.apartmentsCount,
                            selectedStatus: state.apartmentStatusFilter,
                            selectedRooms: state.apartmentRoomsFilter,
                            isGridView: state.isGridView,
                            showMapView: state.showMapView,
                            hasCoordinates: state.selectedProject!.latitude != null &&
                                state.selectedProject!.longitude != null,
                            onStatusChanged: (status) {
                              context.read<ProjectsBloc>().add(
                                    ChangeApartmentStatusFilter(status),
                                  );
                            },
                            onRoomsChanged: (rooms) {
                              context.read<ProjectsBloc>().add(
                                    ChangeApartmentRoomsFilter(rooms),
                                  );
                            },
                            onToggleView: () {
                              context.read<ProjectsBloc>().add(const ToggleViewMode());
                            },
                            onToggleMap: () {
                              context.read<ProjectsBloc>().add(const ToggleMapView());
                            },
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),

                // Map View (conditional)
                if (state.showMapView && state.selectedProject != null)
                  SliverToBoxAdapter(
                    child: ProjectsMapPlaceholder(project: state.selectedProject!),
                  ),

                // Apartments List/Grid
                if (state.isLoadingApartments && state.apartments.isEmpty)
                  SliverToBoxAdapter(
                    child: ApartmentsLoadingSkeleton(isGridView: state.isGridView),
                  )
                else if (state.apartments.isEmpty && !state.isLoadingApartments)
                  const SliverToBoxAdapter(
                    child: ProjectsEmptyApartments(),
                  )
                else if (state.isGridView)
                  _buildApartmentsGrid(state.apartments)
                else
                  _buildApartmentsList(state.apartments),

                // Loading more indicator
                if (state.isLoadingMoreApartments)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Center(
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Pagination info
                if (state.apartments.isNotEmpty && !state.isLoadingMoreApartments)
                  SliverToBoxAdapter(
                    child: ProjectsPaginationInfo(
                      showing: state.apartments.length,
                      total: state.apartmentsCount,
                      hasMore: state.hasMoreApartments,
                    ),
                  ),

                // Builder History Section
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      BuilderHistorySection(
                        history: state.builderHistory,
                        isLoading: state.isLoadingBuilderHistory,
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSearchSheet(BuildContext context) {
    final state = context.read<ProjectsBloc>().state;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => ProjectsSearchSheet(
        projects: state.projects,
        apartments: state.apartments,
        onProjectSelected: (projectId) {
          context.read<ProjectsBloc>().add(SelectProject(projectId));
        },
        onApartmentSelected: (apartmentId) {
          _navigateToApartmentDetail(apartmentId);
        },
      ),
    );
  }

  Widget _buildApartmentsList(List<Apartment> apartments) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final apartment = apartments[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ApartmentListRow(
              apartment: apartment,
              index: index,
              onTap: () => _navigateToApartmentDetail(apartment.id),
            ),
          );
        },
        childCount: apartments.length,
      ),
    );
  }

  Widget _buildApartmentsGrid(List<Apartment> apartments) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final apartment = apartments[index];
            return ApartmentGridCard(
              apartment: apartment,
              index: index,
              onTap: () => _navigateToApartmentDetail(apartment.id),
            );
          },
          childCount: apartments.length,
        ),
      ),
    );
  }

  void _navigateToApartmentDetail(int apartmentId) {
    context.push(RouteNames.apartmentDetailPath(apartmentId));
  }
}
