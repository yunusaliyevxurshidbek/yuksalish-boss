import 'package:equatable/equatable.dart';

/// Enum for contract status types
enum ContractStatus {
  pending,
  active,
  completed,
  cancelled;

  static ContractStatus fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'pending' => ContractStatus.pending,
      'active' => ContractStatus.active,
      'completed' => ContractStatus.completed,
      'cancelled' => ContractStatus.cancelled,
      _ => ContractStatus.pending,
    };
  }

  String toApiString() {
    return switch (this) {
      ContractStatus.pending => 'pending',
      ContractStatus.active => 'active',
      ContractStatus.completed => 'completed',
      ContractStatus.cancelled => 'cancelled',
    };
  }

  String get displayName {
    return switch (this) {
      ContractStatus.pending => 'Kutilmoqda',
      ContractStatus.active => 'Faol',
      ContractStatus.completed => 'Yakunlangan',
      ContractStatus.cancelled => 'Bekor qilingan',
    };
  }
}

/// Contract model representing a CRM contract
class Contract extends Equatable {
  final int id;
  final ContractStatus status;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String currency;

  const Contract({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.currency,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'] as int,
      status: ContractStatus.fromString(json['status'] as String?),
      totalAmount: _parseDouble(json['total_amount']),
      paidAmount: _parseDouble(json['paid_amount']),
      remainingAmount: _parseDouble(json['remaining_amount']),
      currency: json['currency'] as String? ?? 'UZS',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [
        id,
        status,
        totalAmount,
        paidAmount,
        remainingAmount,
        currency,
      ];
}

/// Paginated response for contracts list
class ContractsPaginatedResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Contract> results;

  const ContractsPaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ContractsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    final results = <Contract>[];
    final rawResults = json['results'];
    if (rawResults is List) {
      for (final item in rawResults) {
        if (item is Map<String, dynamic>) {
          results.add(Contract.fromJson(item));
        }
      }
    }
    return ContractsPaginatedResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: results,
    );
  }
}
