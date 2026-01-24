/// Model for Overdue Payment item
/// GET /crm/payments/overdue/
class OverduePaymentModel {
  final int id;
  final String contractNumber;
  final String clientName;
  final double amount;
  final String currency;
  final DateTime dueDate;
  final String status;

  const OverduePaymentModel({
    required this.id,
    required this.contractNumber,
    required this.clientName,
    required this.amount,
    required this.currency,
    required this.dueDate,
    required this.status,
  });

  factory OverduePaymentModel.fromJson(Map<String, dynamic> json) {
    return OverduePaymentModel(
      id: json['id'] as int? ?? 0,
      contractNumber: json['contract_number'] as String? ?? '',
      clientName: json['client_name'] as String? ?? '',
      amount: _parseAmount(json['amount']),
      currency: json['currency'] as String? ?? 'UZS',
      dueDate: _parseDate(json['due_date']),
      status: json['status'] as String? ?? 'overdue',
    );
  }

  static double _parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
