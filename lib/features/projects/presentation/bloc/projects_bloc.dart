import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/projects_repository.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectsRepository repository;

  ProjectsBloc({required this.repository}) : super(ProjectsState.initial()) {
    on<LoadProjects>(_onLoadProjects);
    on<ChangeFilter>(_onChangeFilter);
    on<SelectProject>(_onSelectProject);
    on<LoadProjectDetail>(_onLoadProjectDetail);
    on<LoadApartments>(_onLoadApartments);
    on<LoadMoreApartments>(_onLoadMoreApartments);
    on<ChangeApartmentStatusFilter>(_onChangeApartmentStatusFilter);
    on<ChangeApartmentRoomsFilter>(_onChangeApartmentRoomsFilter);
    on<LoadBuilderHistory>(_onLoadBuilderHistory);
    on<ToggleViewMode>(_onToggleViewMode);
    on<ToggleMapView>(_onToggleMapView);
    on<RefreshProjects>(_onRefreshProjects);
    on<UpdateApartmentStatus>(_onUpdateApartmentStatus);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(status: ProjectsStatus.loading, clearError: true));

    try {
      final projects = await repository.getProjects(filter: event.filter);
      final counts = await repository.getProjectsCounts();

      // Auto-select first project if available
      final firstProject = projects.isNotEmpty ? projects.first : null;

      emit(state.copyWith(
        status: ProjectsStatus.loaded,
        projects: projects,
        currentFilter: event.filter,
        selectedProjectId: firstProject?.id,
        selectedProject: firstProject,
        activeCount: (counts[ProjectStatus.underConstruction] ?? 0) +
            (counts[ProjectStatus.active] ?? 0),
        completedCount: (counts[ProjectStatus.completed] ?? 0) +
            (counts[ProjectStatus.ready] ?? 0),
        plannedCount: counts[ProjectStatus.presale] ?? 0,
      ));

      // Load apartments for first project
      if (firstProject != null) {
        add(LoadApartments(projectId: firstProject.id));
        add(LoadBuilderHistory(firstProject.id));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onChangeFilter(
    ChangeFilter event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(status: ProjectsStatus.loading, currentFilter: event.filter));

    try {
      final projects = await repository.getProjects(filter: event.filter);

      // Auto-select first project if available
      final firstProject = projects.isNotEmpty ? projects.first : null;

      emit(state.copyWith(
        status: ProjectsStatus.loaded,
        projects: projects,
        selectedProjectId: firstProject?.id,
        selectedProject: firstProject,
        apartments: const [],
        apartmentsCount: 0,
        builderHistory: const [],
      ));

      // Load apartments for first project
      if (firstProject != null) {
        add(LoadApartments(projectId: firstProject.id));
        add(LoadBuilderHistory(firstProject.id));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProjectsStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSelectProject(
    SelectProject event,
    Emitter<ProjectsState> emit,
  ) async {
    final project = state.projects.firstWhere(
      (p) => p.id == event.projectId,
      orElse: () => state.projects.first,
    );

    emit(state.copyWith(
      selectedProjectId: event.projectId,
      selectedProject: project,
      apartments: const [],
      apartmentsCount: 0,
      currentApartmentsPage: 1,
      hasMoreApartments: false,
      builderHistory: const [],
      clearApartmentStatusFilter: true,
      clearApartmentRoomsFilter: true,
    ));

    // Load apartments and builder history for selected project
    add(LoadApartments(projectId: event.projectId));
    add(LoadBuilderHistory(event.projectId));
  }

  Future<void> _onLoadProjectDetail(
    LoadProjectDetail event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingApartments: true,
      clearError: true,
    ));

    try {
      final project = await repository.getProjectById(event.projectId);

      emit(state.copyWith(
        selectedProjectId: event.projectId,
        selectedProject: project,
        isLoadingApartments: false,
      ));

      // Load apartments and history
      add(LoadApartments(projectId: event.projectId));
      add(LoadBuilderHistory(event.projectId));
    } catch (e) {
      emit(state.copyWith(
        isLoadingApartments: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadApartments(
    LoadApartments event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingApartments: true,
      currentApartmentsPage: event.page,
      apartmentStatusFilter: event.statusFilter,
      apartmentRoomsFilter: event.roomsFilter,
      clearApartmentStatusFilter: event.statusFilter == null,
      clearApartmentRoomsFilter: event.roomsFilter == null,
    ));

    try {
      final response = await repository.getApartments(
        projectId: event.projectId,
        status: event.statusFilter,
        rooms: event.roomsFilter,
        page: event.page,
      );

      emit(state.copyWith(
        apartments: response.results,
        apartmentsCount: response.count,
        hasMoreApartments: response.hasNextPage,
        isLoadingApartments: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingApartments: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreApartments(
    LoadMoreApartments event,
    Emitter<ProjectsState> emit,
  ) async {
    if (!state.hasMoreApartments ||
        state.isLoadingMoreApartments ||
        state.selectedProjectId == null) {
      return;
    }

    emit(state.copyWith(isLoadingMoreApartments: true));

    try {
      final nextPage = state.currentApartmentsPage + 1;
      final response = await repository.getApartments(
        projectId: state.selectedProjectId!,
        status: state.apartmentStatusFilter,
        rooms: state.apartmentRoomsFilter,
        page: nextPage,
      );

      emit(state.copyWith(
        apartments: [...state.apartments, ...response.results],
        currentApartmentsPage: nextPage,
        hasMoreApartments: response.hasNextPage,
        isLoadingMoreApartments: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMoreApartments: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onChangeApartmentStatusFilter(
    ChangeApartmentStatusFilter event,
    Emitter<ProjectsState> emit,
  ) async {
    if (state.selectedProjectId == null) return;

    add(LoadApartments(
      projectId: state.selectedProjectId!,
      statusFilter: event.status,
      roomsFilter: state.apartmentRoomsFilter,
      page: 1,
    ));
  }

  Future<void> _onChangeApartmentRoomsFilter(
    ChangeApartmentRoomsFilter event,
    Emitter<ProjectsState> emit,
  ) async {
    if (state.selectedProjectId == null) return;

    add(LoadApartments(
      projectId: state.selectedProjectId!,
      statusFilter: state.apartmentStatusFilter,
      roomsFilter: event.rooms,
      page: 1,
    ));
  }

  Future<void> _onLoadBuilderHistory(
    LoadBuilderHistory event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isLoadingBuilderHistory: true));

    try {
      final history = await repository.getBuilderHistory(event.projectId);

      emit(state.copyWith(
        builderHistory: history,
        isLoadingBuilderHistory: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingBuilderHistory: false,
        builderHistory: const [],
      ));
    }
  }

  void _onToggleViewMode(
    ToggleViewMode event,
    Emitter<ProjectsState> emit,
  ) {
    emit(state.copyWith(isGridView: !state.isGridView));
  }

  void _onToggleMapView(
    ToggleMapView event,
    Emitter<ProjectsState> emit,
  ) {
    emit(state.copyWith(showMapView: !state.showMapView));
  }

  Future<void> _onRefreshProjects(
    RefreshProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final projects = await repository.getProjects(filter: state.currentFilter);
      final counts = await repository.getProjectsCounts();

      // Keep current selection if still exists
      Project? selectedProject;
      if (state.selectedProjectId != null) {
        selectedProject = projects.firstWhere(
          (p) => p.id == state.selectedProjectId,
          orElse: () => projects.isNotEmpty ? projects.first : state.selectedProject!,
        );
      } else if (projects.isNotEmpty) {
        selectedProject = projects.first;
      }

      emit(state.copyWith(
        status: ProjectsStatus.loaded,
        projects: projects,
        isRefreshing: false,
        selectedProjectId: selectedProject?.id,
        selectedProject: selectedProject,
        activeCount: (counts[ProjectStatus.underConstruction] ?? 0) +
            (counts[ProjectStatus.active] ?? 0),
        completedCount: (counts[ProjectStatus.completed] ?? 0) +
            (counts[ProjectStatus.ready] ?? 0),
        plannedCount: counts[ProjectStatus.presale] ?? 0,
      ));

      // Reload apartments if project is selected
      if (selectedProject != null) {
        add(LoadApartments(
          projectId: selectedProject.id,
          statusFilter: state.apartmentStatusFilter,
          roomsFilter: state.apartmentRoomsFilter,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isRefreshing: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateApartmentStatus(
    UpdateApartmentStatus event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      final updatedApartment = await repository.updateApartmentStatus(
        event.apartmentId,
        event.newStatus,
      );

      // Update the apartment in the list
      final updatedApartments = state.apartments.map((apt) {
        if (apt.id == event.apartmentId) {
          return updatedApartment;
        }
        return apt;
      }).toList();

      emit(state.copyWith(apartments: updatedApartments));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
