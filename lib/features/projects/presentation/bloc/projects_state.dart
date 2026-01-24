import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';
import '../../data/repositories/projects_repository.dart';

enum ProjectsStatus { initial, loading, loaded, error }

class ProjectsState extends Equatable {
  // Projects
  final ProjectsStatus status;
  final List<Project> projects;
  final ProjectFilter currentFilter;
  final bool isRefreshing;

  // Selected project
  final int? selectedProjectId;
  final Project? selectedProject;

  // Apartments with pagination
  final List<Apartment> apartments;
  final int apartmentsCount;
  final int currentApartmentsPage;
  final bool hasMoreApartments;
  final bool isLoadingApartments;
  final bool isLoadingMoreApartments;
  final String? apartmentStatusFilter;
  final int? apartmentRoomsFilter;

  // Builder history
  final List<BuilderHistoryModel> builderHistory;
  final bool isLoadingBuilderHistory;

  // UI toggles
  final bool isGridView;
  final bool showMapView;

  // Project stats (for finance tab)
  final ProjectStats? projectStats;
  final bool isLoadingProjectStats;

  // Statistics
  final int activeCount;
  final int completedCount;
  final int plannedCount;

  // Error handling
  final String? error;

  const ProjectsState({
    this.status = ProjectsStatus.initial,
    this.projects = const [],
    this.currentFilter = ProjectFilter.all,
    this.isRefreshing = false,
    this.selectedProjectId,
    this.selectedProject,
    this.apartments = const [],
    this.apartmentsCount = 0,
    this.currentApartmentsPage = 1,
    this.hasMoreApartments = false,
    this.isLoadingApartments = false,
    this.isLoadingMoreApartments = false,
    this.apartmentStatusFilter,
    this.apartmentRoomsFilter,
    this.builderHistory = const [],
    this.isLoadingBuilderHistory = false,
    this.isGridView = false,
    this.showMapView = false,
    this.projectStats,
    this.isLoadingProjectStats = false,
    this.activeCount = 0,
    this.completedCount = 0,
    this.plannedCount = 0,
    this.error,
  });

  /// Initial state.
  factory ProjectsState.initial() => const ProjectsState(
        status: ProjectsStatus.initial,
      );

  /// Get total projects count.
  int get totalCount => projects.length;

  /// Check if loading.
  bool get isLoading => status == ProjectsStatus.loading;

  /// Check if loaded.
  bool get isLoaded => status == ProjectsStatus.loaded;

  /// Check if has error.
  bool get hasError => status == ProjectsStatus.error;

  /// Check if projects list is empty.
  bool get isEmpty => projects.isEmpty && isLoaded;

  /// Check if apartments list is empty.
  bool get apartmentsEmpty => apartments.isEmpty && !isLoadingApartments;

  /// Check if has selected project.
  bool get hasSelectedProject => selectedProject != null;

  /// Check if builder history is empty.
  bool get builderHistoryEmpty =>
      builderHistory.isEmpty && !isLoadingBuilderHistory;

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<Project>? projects,
    ProjectFilter? currentFilter,
    bool? isRefreshing,
    int? selectedProjectId,
    Project? selectedProject,
    List<Apartment>? apartments,
    int? apartmentsCount,
    int? currentApartmentsPage,
    bool? hasMoreApartments,
    bool? isLoadingApartments,
    bool? isLoadingMoreApartments,
    String? apartmentStatusFilter,
    int? apartmentRoomsFilter,
    List<BuilderHistoryModel>? builderHistory,
    bool? isLoadingBuilderHistory,
    bool? isGridView,
    bool? showMapView,
    ProjectStats? projectStats,
    bool? isLoadingProjectStats,
    int? activeCount,
    int? completedCount,
    int? plannedCount,
    String? error,
    bool clearSelectedProject = false,
    bool clearApartmentStatusFilter = false,
    bool clearApartmentRoomsFilter = false,
    bool clearError = false,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      currentFilter: currentFilter ?? this.currentFilter,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      selectedProjectId: clearSelectedProject
          ? null
          : (selectedProjectId ?? this.selectedProjectId),
      selectedProject: clearSelectedProject
          ? null
          : (selectedProject ?? this.selectedProject),
      apartments: apartments ?? this.apartments,
      apartmentsCount: apartmentsCount ?? this.apartmentsCount,
      currentApartmentsPage:
          currentApartmentsPage ?? this.currentApartmentsPage,
      hasMoreApartments: hasMoreApartments ?? this.hasMoreApartments,
      isLoadingApartments: isLoadingApartments ?? this.isLoadingApartments,
      isLoadingMoreApartments:
          isLoadingMoreApartments ?? this.isLoadingMoreApartments,
      apartmentStatusFilter: clearApartmentStatusFilter
          ? null
          : (apartmentStatusFilter ?? this.apartmentStatusFilter),
      apartmentRoomsFilter: clearApartmentRoomsFilter
          ? null
          : (apartmentRoomsFilter ?? this.apartmentRoomsFilter),
      builderHistory: builderHistory ?? this.builderHistory,
      isLoadingBuilderHistory:
          isLoadingBuilderHistory ?? this.isLoadingBuilderHistory,
      isGridView: isGridView ?? this.isGridView,
      showMapView: showMapView ?? this.showMapView,
      projectStats: projectStats ?? this.projectStats,
      isLoadingProjectStats:
          isLoadingProjectStats ?? this.isLoadingProjectStats,
      activeCount: activeCount ?? this.activeCount,
      completedCount: completedCount ?? this.completedCount,
      plannedCount: plannedCount ?? this.plannedCount,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        status,
        projects,
        currentFilter,
        isRefreshing,
        selectedProjectId,
        selectedProject,
        apartments,
        apartmentsCount,
        currentApartmentsPage,
        hasMoreApartments,
        isLoadingApartments,
        isLoadingMoreApartments,
        apartmentStatusFilter,
        apartmentRoomsFilter,
        builderHistory,
        isLoadingBuilderHistory,
        isGridView,
        showMapView,
        projectStats,
        isLoadingProjectStats,
        activeCount,
        completedCount,
        plannedCount,
        error,
      ];
}
