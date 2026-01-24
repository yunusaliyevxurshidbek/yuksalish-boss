import 'package:equatable/equatable.dart';

import '../../data/models/funnel_models.dart';

enum FunnelAnalysisStatus { initial, loading, loaded, error }

class FunnelAnalysisState extends Equatable {
  final FunnelAnalysisStatus status;
  final List<FunnelStage> stages;
  final List<FunnelKpi> kpis;
  final String? errorMessage;

  const FunnelAnalysisState({
    this.status = FunnelAnalysisStatus.initial,
    this.stages = const [],
    this.kpis = const [],
    this.errorMessage,
  });

  int get totalCount => stages.fold<int>(0, (sum, stage) => sum + stage.count);

  FunnelAnalysisState copyWith({
    FunnelAnalysisStatus? status,
    List<FunnelStage>? stages,
    List<FunnelKpi>? kpis,
    String? errorMessage,
  }) {
    return FunnelAnalysisState(
      status: status ?? this.status,
      stages: stages ?? this.stages,
      kpis: kpis ?? this.kpis,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == FunnelAnalysisStatus.loading;
  bool get isLoaded => status == FunnelAnalysisStatus.loaded;
  bool get hasError => status == FunnelAnalysisStatus.error;

  @override
  List<Object?> get props => [status, stages, kpis, errorMessage];
}
