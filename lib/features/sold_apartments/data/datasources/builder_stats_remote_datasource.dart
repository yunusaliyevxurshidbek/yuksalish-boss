import 'package:dio/dio.dart';

import '../models/builder_stats_model.dart';

/// Remote data source for builder statistics
abstract class BuilderStatsRemoteDataSource {
  /// Get builder statistics from /projects/builder/stats/
  Future<BuilderStats> getBuilderStats();
}

class BuilderStatsRemoteDataSourceImpl implements BuilderStatsRemoteDataSource {
  final Dio _dio;

  BuilderStatsRemoteDataSourceImpl(this._dio);

  @override
  Future<BuilderStats> getBuilderStats() async {
    final response = await _dio.get('/projects/builder/stats/');
    return BuilderStats.fromJson(response.data as Map<String, dynamic>);
  }
}
