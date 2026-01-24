import 'package:equatable/equatable.dart';
import '../../data/models/apartment.dart';
import '../../data/repositories/projects_repository.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

/// Load all projects.
class LoadProjects extends ProjectsEvent {
  final ProjectFilter filter;

  const LoadProjects({this.filter = ProjectFilter.all});

  @override
  List<Object?> get props => [filter];
}

/// Change the current filter.
class ChangeFilter extends ProjectsEvent {
  final ProjectFilter filter;

  const ChangeFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Select a project from carousel.
class SelectProject extends ProjectsEvent {
  final int projectId;

  const SelectProject(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

/// Load a specific project's details.
class LoadProjectDetail extends ProjectsEvent {
  final int projectId;

  const LoadProjectDetail(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

/// Load apartments for a project with pagination.
class LoadApartments extends ProjectsEvent {
  final int projectId;
  final String? statusFilter;
  final int? roomsFilter;
  final int page;

  const LoadApartments({
    required this.projectId,
    this.statusFilter,
    this.roomsFilter,
    this.page = 1,
  });

  @override
  List<Object?> get props => [projectId, statusFilter, roomsFilter, page];
}

/// Load more apartments (pagination).
class LoadMoreApartments extends ProjectsEvent {
  const LoadMoreApartments();
}

/// Change apartment status filter.
class ChangeApartmentStatusFilter extends ProjectsEvent {
  final String? status;

  const ChangeApartmentStatusFilter(this.status);

  @override
  List<Object?> get props => [status];
}

/// Change apartment rooms filter.
class ChangeApartmentRoomsFilter extends ProjectsEvent {
  final int? rooms;

  const ChangeApartmentRoomsFilter(this.rooms);

  @override
  List<Object?> get props => [rooms];
}

/// Load builder history for a project.
class LoadBuilderHistory extends ProjectsEvent {
  final int projectId;

  const LoadBuilderHistory(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

/// Toggle apartments view mode (list/grid).
class ToggleViewMode extends ProjectsEvent {
  const ToggleViewMode();
}

/// Toggle map view.
class ToggleMapView extends ProjectsEvent {
  const ToggleMapView();
}

/// Refresh projects list.
class RefreshProjects extends ProjectsEvent {
  const RefreshProjects();
}

/// Update apartment status.
class UpdateApartmentStatus extends ProjectsEvent {
  final int apartmentId;
  final ApartmentStatus newStatus;

  const UpdateApartmentStatus({
    required this.apartmentId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [apartmentId, newStatus];
}
