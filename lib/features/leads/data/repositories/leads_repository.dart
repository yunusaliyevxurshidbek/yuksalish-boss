import '../datasources/leads_remote_datasource.dart';
import '../models/lead_model.dart';
import '../models/leads_paginated_response.dart';

/// Repository for leads data operations
abstract class LeadsRepository {
  /// Get paginated list of leads
  Future<LeadsPaginatedResponse> getLeads({
    LeadStage? stage,
    String? search,
    String? order,
    int page = 1,
  });

  /// Get lead details by ID
  Future<Lead> getLeadById(int id);

  /// Get total leads count (for dashboard)
  Future<int> getLeadsCount();

  /// Get leads count by stage
  Future<Map<LeadStage, int>> getLeadsCountByStage();
}

/// Implementation of LeadsRepository
class LeadsRepositoryImpl implements LeadsRepository {
  final LeadsRemoteDataSource _remoteDataSource;

  LeadsRepositoryImpl(this._remoteDataSource);

  @override
  Future<LeadsPaginatedResponse> getLeads({
    LeadStage? stage,
    String? search,
    String? order,
    int page = 1,
  }) async {
    return await _remoteDataSource.getLeads(
      stage: stage,
      search: search,
      order: order,
      page: page,
    );
  }

  @override
  Future<Lead> getLeadById(int id) async {
    return await _remoteDataSource.getLeadById(id);
  }

  @override
  Future<int> getLeadsCount() async {
    final response = await _remoteDataSource.getLeads(page: 1);
    return response.count;
  }

  @override
  Future<Map<LeadStage, int>> getLeadsCountByStage() async {
    // Fetch counts for each stage in parallel
    final results = await Future.wait([
      _remoteDataSource.getLeads(stage: LeadStage.newLead, page: 1),
      _remoteDataSource.getLeads(stage: LeadStage.contacted, page: 1),
      _remoteDataSource.getLeads(stage: LeadStage.qualified, page: 1),
      _remoteDataSource.getLeads(stage: LeadStage.showing, page: 1),
      _remoteDataSource.getLeads(stage: LeadStage.negotiation, page: 1),
      _remoteDataSource.getLeads(stage: LeadStage.reservation, page: 1),
      _remoteDataSource.getLeads(stage: LeadStage.contract, page: 1),
      _remoteDataSource.getLeads(stage: LeadStage.won, page: 1),
      _remoteDataSource.getLeads(stage: LeadStage.lost, page: 1),
    ]);

    return {
      LeadStage.newLead: results[0].count,
      LeadStage.contacted: results[1].count,
      LeadStage.qualified: results[2].count,
      LeadStage.showing: results[3].count,
      LeadStage.negotiation: results[4].count,
      LeadStage.reservation: results[5].count,
      LeadStage.contract: results[6].count,
      LeadStage.won: results[7].count,
      LeadStage.lost: results[8].count,
    };
  }
}
