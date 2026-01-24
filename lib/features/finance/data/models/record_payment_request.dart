import 'package:equatable/equatable.dart';

import 'payment.dart';

/// Request model for recording a new payment
class RecordPaymentRequest extends Equatable {
  const RecordPaymentRequest({
    required this.contractId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.paymentDate,
    this.notes,
  });

  final int contractId;
  final double amount;
  final String currency;
  final PaymentType method;
  final DateTime paymentDate;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      'contract': contractId,
      'amount': amount.toString(),
      'currency': currency,
      'method': method.toApiString(),
      'payment_date': paymentDate.toIso8601String().split('T').first,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  RecordPaymentRequest copyWith({
    int? contractId,
    double? amount,
    String? currency,
    PaymentType? method,
    DateTime? paymentDate,
    String? notes,
  }) {
    return RecordPaymentRequest(
      contractId: contractId ?? this.contractId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      method: method ?? this.method,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        contractId,
        amount,
        currency,
        method,
        paymentDate,
        notes,
      ];
}
