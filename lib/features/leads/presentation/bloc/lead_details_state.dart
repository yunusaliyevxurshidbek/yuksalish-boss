import 'package:equatable/equatable.dart';

import '../../data/models/lead_model.dart';

enum LeadDetailsStatus { initial, loading, loaded, error }

class LeadDetailsState extends Equatable {
  final LeadDetailsStatus status;
  final Lead? lead;
  final String? errorMessage;

  const LeadDetailsState({
    required this.status,
    this.lead,
    this.errorMessage,
  });

  factory LeadDetailsState.initial() => const LeadDetailsState(
        status: LeadDetailsStatus.initial,
      );

  LeadDetailsState copyWith({
    LeadDetailsStatus? status,
    Lead? lead,
    String? errorMessage,
  }) {
    return LeadDetailsState(
      status: status ?? this.status,
      lead: lead ?? this.lead,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == LeadDetailsStatus.loading;
  bool get isLoaded => status == LeadDetailsStatus.loaded;
  bool get hasError => status == LeadDetailsStatus.error;

  @override
  List<Object?> get props => [status, lead, errorMessage];
}
