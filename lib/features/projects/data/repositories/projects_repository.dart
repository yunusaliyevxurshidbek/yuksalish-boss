import '../datasources/projects_remote_datasource.dart';
import '../models/models.dart';

/// Filter type for projects list.
enum ProjectFilter {
  all,
  active,
  completed,
  planned,
}

/// Extension to get display text for project filter.
extension ProjectFilterExtension on ProjectFilter {
  String get displayName {
    switch (this) {
      case ProjectFilter.all:
        return 'Barchasi';
      case ProjectFilter.active:
        return 'Faol';
      case ProjectFilter.completed:
        return 'Tugallangan';
      case ProjectFilter.planned:
        return 'Reja';
    }
  }

  /// Get API status value for filtering.
  String? get apiStatusValue {
    switch (this) {
      case ProjectFilter.all:
        return null;
      case ProjectFilter.active:
        return 'under_construction';
      case ProjectFilter.completed:
        return 'completed';
      case ProjectFilter.planned:
        return 'presale';
    }
  }
}

/// Repository for projects data.
abstract class ProjectsRepository {
  /// Get list of all projects.
  Future<List<Project>> getProjects({ProjectFilter filter = ProjectFilter.all});

  /// Get project details by ID.
  Future<Project> getProjectById(int id);

  /// Get paginated apartments for a project.
  Future<ApartmentsPaginatedResponse> getApartments({
    required int projectId,
    String? status,
    int? rooms,
    String? ordering,
    int page = 1,
  });

  /// Get apartment details by ID.
  Future<Apartment> getApartmentById(int id);

  /// Get builder history for a project.
  Future<List<BuilderHistoryModel>> getBuilderHistory(int projectId);

  /// Update apartment status.
  Future<Apartment> updateApartmentStatus(int apartmentId, ApartmentStatus newStatus);

  /// Get count of projects by status.
  Future<Map<ProjectStatus, int>> getProjectsCounts();
}

/// Implementation of ProjectsRepository using remote data source.
class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDataSource _remoteDataSource;

  ProjectsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Project>> getProjects({
    ProjectFilter filter = ProjectFilter.all,
  }) async {
    final projects = await _remoteDataSource.getProjects();

    if (filter == ProjectFilter.all) {
      return projects;
    }

    // Filter by status locally
    return projects.where((project) {
      switch (filter) {
        case ProjectFilter.active:
          return project.status == ProjectStatus.underConstruction ||
              project.status == ProjectStatus.active;
        case ProjectFilter.completed:
          return project.status == ProjectStatus.completed ||
              project.status == ProjectStatus.ready;
        case ProjectFilter.planned:
          return project.status == ProjectStatus.presale;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Future<Project> getProjectById(int id) async {
    return _remoteDataSource.getProjectById(id);
  }

  @override
  Future<ApartmentsPaginatedResponse> getApartments({
    required int projectId,
    String? status,
    int? rooms,
    String? ordering,
    int page = 1,
  }) async {
    return _remoteDataSource.getApartments(
      projectId: projectId,
      status: status,
      rooms: rooms,
      ordering: ordering,
      page: page,
    );
  }

  @override
  Future<Apartment> getApartmentById(int id) async {
    return _remoteDataSource.getApartmentById(id);
  }

  @override
  Future<List<BuilderHistoryModel>> getBuilderHistory(int projectId) async {
    return _remoteDataSource.getBuilderHistory(projectId);
  }

  @override
  Future<Apartment> updateApartmentStatus(
    int apartmentId,
    ApartmentStatus newStatus,
  ) async {
    return _remoteDataSource.updateApartmentStatus(
      apartmentId,
      newStatus.apiValue,
    );
  }

  @override
  Future<Map<ProjectStatus, int>> getProjectsCounts() async {
    final projects = await _remoteDataSource.getProjects();

    final counts = <ProjectStatus, int>{};
    for (final status in ProjectStatus.values) {
      counts[status] = projects.where((p) => p.status == status).length;
    }
    return counts;
  }
}
