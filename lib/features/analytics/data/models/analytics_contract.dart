import 'package:equatable/equatable.dart';

/// Contract model for analytics calculations.
class AnalyticsContract extends Equatable {
  final int id;
  final String? contractNumber;
  final String clientName;
  final String? apartmentId;
  final String? projectName;
  final String status;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String currency;
  final int? assignedTo;
  final String? assignedToName;
  final DateTime? signedAt;
  final DateTime? createdAt;

  const AnalyticsContract({
    required this.id,
    this.contractNumber,
    required this.clientName,
    this.apartmentId,
    this.projectName,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.currency,
    this.assignedTo,
    this.assignedToName,
    this.signedAt,
    this.createdAt,
  });

  factory AnalyticsContract.fromJson(Map<String, dynamic> json) {
    return AnalyticsContract(
      id: json['id'] as int? ?? 0,
      contractNumber: json['contract_number'] as String?,
      clientName: json['client_name'] as String? ?? '',
      apartmentId: (json['apartment'] ?? json['apartment_id'])?.toString(),
      projectName: json['project_name'] as String?,
      status: (json['status'] as String? ?? '').toLowerCase(),
      totalAmount: _parseDouble(json['total_amount']),
      paidAmount: _parseDouble(json['paid_amount']),
      remainingAmount: _parseDouble(json['remaining_amount']),
      currency: json['currency'] as String? ?? 'UZS',
      assignedTo: json['assigned_to'] is int ? json['assigned_to'] as int : null,
      assignedToName: json['assigned_to'] is String
          ? json['assigned_to'] as String
          : (json['assigned_to_name'] as String?),
      signedAt: _parseDate(json['signed_at']),
      createdAt: _parseDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contract_number': contractNumber,
      'client_name': clientName,
      'apartment_id': apartmentId,
      'project_name': projectName,
      'status': status,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'currency': currency,
      'assigned_to': assignedTo,
      'assigned_to_name': assignedToName,
      'signed_at': signedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  bool get isCompleted => status == 'completed';

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        contractNumber,
        clientName,
        apartmentId,
        projectName,
        status,
        totalAmount,
        paidAmount,
        remainingAmount,
        currency,
        assignedTo,
        assignedToName,
        signedAt,
        createdAt,
      ];
}
