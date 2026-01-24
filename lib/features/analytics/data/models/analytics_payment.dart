import 'package:equatable/equatable.dart';

/// Payment model for analytics charts.
class AnalyticsPayment extends Equatable {
  final int id;
  final String? contractNumber;
  final String clientName;
  final double amount;
  final String currency;
  final DateTime? paymentDate;
  final String status;

  const AnalyticsPayment({
    required this.id,
    this.contractNumber,
    required this.clientName,
    required this.amount,
    required this.currency,
    this.paymentDate,
    required this.status,
  });

  factory AnalyticsPayment.fromJson(Map<String, dynamic> json) {
    return AnalyticsPayment(
      id: json['id'] as int? ?? 0,
      contractNumber: json['contract_number'] as String?,
      clientName: json['client_name'] as String? ?? '',
      amount: _parseDouble(json['amount']),
      currency: json['currency'] as String? ?? 'UZS',
      paymentDate: _parseDate(json['payment_date']),
      status: (json['status'] as String? ?? '').toLowerCase(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contract_number': contractNumber,
      'client_name': clientName,
      'amount': amount,
      'currency': currency,
      'payment_date': paymentDate?.toIso8601String(),
      'status': status,
    };
  }

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
        amount,
        currency,
        paymentDate,
        status,
      ];
}
