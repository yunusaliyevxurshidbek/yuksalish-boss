import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

/// Payment method/type enum
enum PaymentType {
  cash,
  card,
  transfer,
  akt;

  static PaymentType fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'cash' => PaymentType.cash,
      'card' => PaymentType.card,
      'transfer' => PaymentType.transfer,
      'bank' => PaymentType.transfer, // backward compatibility
      'akt' => PaymentType.akt,
      _ => PaymentType.cash,
    };
  }

  String toApiString() {
    return switch (this) {
      PaymentType.cash => 'cash',
      PaymentType.card => 'card',
      PaymentType.transfer => 'transfer',
      PaymentType.akt => 'akt',
    };
  }

  /// Get payment type label (translated)
  String get label {
    return switch (this) {
      PaymentType.cash => 'finance_payment_type_cash'.tr(),
      PaymentType.card => 'finance_payment_type_card'.tr(),
      PaymentType.transfer => 'finance_payment_type_transfer'.tr(),
      PaymentType.akt => 'finance_payment_type_akt'.tr(),
    };
  }
}

/// Payment status enum
enum PaymentStatus {
  completed,
  pending,
  overdue,
  cancelled;

  static PaymentStatus fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'completed' => PaymentStatus.completed,
      'pending' => PaymentStatus.pending,
      'overdue' => PaymentStatus.overdue,
      'cancelled' => PaymentStatus.cancelled,
      _ => PaymentStatus.pending,
    };
  }

  String toApiString() {
    return switch (this) {
      PaymentStatus.completed => 'completed',
      PaymentStatus.pending => 'pending',
      PaymentStatus.overdue => 'overdue',
      PaymentStatus.cancelled => 'cancelled',
    };
  }

  /// Get payment status label (translated)
  String get label {
    return switch (this) {
      PaymentStatus.completed => 'finance_payment_status_completed'.tr(),
      PaymentStatus.pending => 'finance_payment_status_pending'.tr(),
      PaymentStatus.overdue => 'finance_payment_status_overdue'.tr(),
      PaymentStatus.cancelled => 'finance_payment_status_cancelled'.tr(),
    };
  }
}

/// Payment model representing a single payment transaction
class Payment extends Equatable {
  const Payment({
    required this.id,
    required this.receiptNumber,
    required this.clientId,
    required this.clientName,
    required this.contractId,
    required this.contractNumber,
    required this.amount,
    required this.currency,
    required this.type,
    required this.date,
    required this.status,
    this.dueDate,
    this.notes,
    this.processedBy,
    this.projectName,
    this.mchjId,
    this.mchjName,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String receiptNumber;
  final int clientId;
  final String clientName;
  final int contractId;
  final String contractNumber;
  final double amount;
  final String currency;
  final PaymentType type;
  final DateTime date;
  final PaymentStatus status;
  final DateTime? dueDate;
  final String? notes;
  final String? processedBy;
  final String? projectName;
  final int? mchjId;
  final String? mchjName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Create Payment from API JSON response
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id']?.toString() ?? '',
      receiptNumber: json['receipt_number'] as String? ?? '',
      clientId: json['client'] as int? ?? 0,
      clientName: json['client_name'] as String? ?? '',
      contractId: json['contract'] as int? ?? 0,
      contractNumber: json['contract_number'] as String? ?? '',
      amount: _parseDouble(json['amount']),
      currency: json['currency'] as String? ?? 'UZS',
      type: PaymentType.fromString(json['method'] as String?),
      date: _parseDate(json['payment_date']),
      status: PaymentStatus.fromString(json['status'] as String?),
      dueDate: _parseNullableDate(json['due_date']),
      notes: json['notes'] as String?,
      processedBy: json['processed_by'] as String?,
      projectName: json['project_name'] as String?,
      mchjId: json['mchj_id'] as int?,
      mchjName: json['mchj_name'] as String?,
      createdAt: _parseNullableDate(json['created_at']),
      updatedAt: _parseNullableDate(json['updated_at']),
    );
  }

  /// Convert Payment to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'contract': contractId,
      'amount': amount.toString(),
      'currency': currency,
      'method': type.toApiString(),
      'payment_date': date.toIso8601String().split('T').first,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static DateTime? _parseNullableDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  /// Get formatted amount based on currency
  String get formattedAmount {
    if (currency == 'USD') {
      return '\$${amount.toStringAsFixed(0)}';
    }
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} mlrd UZS';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} mln UZS';
    }
    return '${amount.toStringAsFixed(0)} UZS';
  }

  /// Get short formatted amount (without currency suffix for cards)
  String get shortFormattedAmount {
    if (currency == 'USD') {
      return '\$${amount.toStringAsFixed(0)}';
    }
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} mln';
    }
    return amount.toStringAsFixed(0);
  }

  /// Get payment type label in Uzbek
  String get typeLabel => type.label;

  /// Get payment status label in Uzbek
  String get statusLabel => status.label;

  Payment copyWith({
    String? id,
    String? receiptNumber,
    int? clientId,
    String? clientName,
    int? contractId,
    String? contractNumber,
    double? amount,
    String? currency,
    PaymentType? type,
    DateTime? date,
    PaymentStatus? status,
    DateTime? dueDate,
    String? notes,
    String? processedBy,
    String? projectName,
    int? mchjId,
    String? mchjName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      contractId: contractId ?? this.contractId,
      contractNumber: contractNumber ?? this.contractNumber,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      date: date ?? this.date,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      processedBy: processedBy ?? this.processedBy,
      projectName: projectName ?? this.projectName,
      mchjId: mchjId ?? this.mchjId,
      mchjName: mchjName ?? this.mchjName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        receiptNumber,
        clientId,
        clientName,
        contractId,
        contractNumber,
        amount,
        currency,
        type,
        date,
        status,
        dueDate,
        notes,
        processedBy,
        projectName,
        mchjId,
        mchjName,
        createdAt,
        updatedAt,
      ];
}

/// Paginated response for payments list
class PaymentsPaginatedResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Payment> results;

  const PaymentsPaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaymentsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    final results = <Payment>[];
    final rawResults = json['results'];
    if (rawResults is List) {
      for (final item in rawResults) {
        if (item is Map<String, dynamic>) {
          results.add(Payment.fromJson(item));
        }
      }
    }
    return PaymentsPaginatedResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: results,
    );
  }
}
