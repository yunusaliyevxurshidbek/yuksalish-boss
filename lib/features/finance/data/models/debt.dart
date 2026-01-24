import 'package:equatable/equatable.dart';

/// Debt status enum
enum DebtStatus {
  active,
  overdue,
  paidOff;

  static DebtStatus fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'active' => DebtStatus.active,
      'overdue' => DebtStatus.overdue,
      'paid_off' => DebtStatus.paidOff,
      'paid' => DebtStatus.paidOff,
      _ => DebtStatus.active,
    };
  }

  String toApiString() {
    return switch (this) {
      DebtStatus.active => 'active',
      DebtStatus.overdue => 'overdue',
      DebtStatus.paidOff => 'paid_off',
    };
  }

  /// Get debt status label in Uzbek
  String get label {
    return switch (this) {
      DebtStatus.active => 'Faol',
      DebtStatus.overdue => 'Kechikkan',
      DebtStatus.paidOff => "To'langan",
    };
  }
}

/// Contract type enum for debt calculation
enum ContractType {
  cash,
  installment,
  mortgage;

  static ContractType fromString(String? value) {
    return switch (value?.toLowerCase()) {
      'cash' => ContractType.cash,
      'installment' => ContractType.installment,
      'mortgage' => ContractType.mortgage,
      _ => ContractType.installment,
    };
  }
}

/// Debt model representing a single debtor record (computed from contract)
class Debt extends Equatable {
  const Debt({
    required this.id,
    required this.contractId,
    required this.contractNumber,
    required this.clientId,
    required this.clientName,
    required this.phoneNumber,
    required this.projectName,
    required this.apartmentNumber,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.overdueAmount,
    required this.monthlyPayment,
    required this.overdueDays,
    required this.maxLateness,
    required this.paidPercentage,
    required this.currency,
    required this.status,
    required this.contractType,
    this.nextPaymentDate,
    this.dueDate,
    this.signedAt,
    this.assignedToId,
    this.assignedToName,
    this.installmentMonths,
  });

  final String id;
  final int contractId;
  final String contractNumber;
  final int clientId;
  final String clientName;
  final String phoneNumber;
  final String projectName;
  final String apartmentNumber;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final double overdueAmount;
  final double monthlyPayment;
  final int overdueDays;
  final int maxLateness;
  final double paidPercentage;
  final String currency;
  final DebtStatus status;
  final ContractType contractType;
  final DateTime? nextPaymentDate;
  final DateTime? dueDate;
  final DateTime? signedAt;
  final int? assignedToId;
  final String? assignedToName;
  final int? installmentMonths;

  /// Create Debt from API contract JSON response
  factory Debt.fromJson(Map<String, dynamic> json) {
    final totalAmount = _parseDouble(json['total_amount']);
    final paidAmount = _parseDouble(json['paid_amount']);
    final remainingAmount = _parseDouble(json['remaining_amount']);
    final monthlyPayment = _parseDouble(json['monthly_payment']);
    final signedAt = _parseNullableDate(json['signed_at']);
    final installmentMonths = json['installment_months'] as int?;

    // Calculate overdue days and amount
    final now = DateTime.now();
    int overdueDays = 0;
    double overdueAmount = 0;

    if (signedAt != null && remainingAmount > 0) {
      final monthsPassed = _monthsBetween(signedAt, now);
      final expectedPaid = monthlyPayment > 0
          ? (monthlyPayment * monthsPassed).clamp(0, totalAmount)
          : 0.0;
      overdueAmount = (expectedPaid - paidAmount).clamp(0, remainingAmount);

      if (overdueAmount > 0 && monthlyPayment > 0) {
        // Calculate days overdue based on last expected payment
        final lastExpectedPaymentMonth = signedAt.add(Duration(days: monthsPassed * 30));
        overdueDays = now.difference(lastExpectedPaymentMonth).inDays.clamp(0, 999);
      }
    }

    // Also check explicit overdue_days from API if provided
    if (json['overdue_days'] != null) {
      overdueDays = json['overdue_days'] as int;
    }
    if (json['overdue_amount'] != null) {
      overdueAmount = _parseDouble(json['overdue_amount']);
    }

    // Calculate paid percentage
    final paidPercentage = totalAmount > 0
        ? ((paidAmount / totalAmount) * 100).clamp(0.0, 100.0)
        : 0.0;

    // Determine status
    DebtStatus status;
    if (json['debt_status'] != null) {
      status = DebtStatus.fromString(json['debt_status'] as String?);
    } else if (remainingAmount <= 0) {
      status = DebtStatus.paidOff;
    } else if (overdueAmount > 0 || overdueDays > 0) {
      status = DebtStatus.overdue;
    } else {
      status = DebtStatus.active;
    }

    return Debt(
      id: 'debt-${json['id']}',
      contractId: json['id'] as int? ?? 0,
      contractNumber: json['contract_number'] as String? ?? '',
      clientId: json['client'] as int? ?? 0,
      clientName: json['client_name'] as String? ?? '',
      phoneNumber: json['client_phone'] as String? ?? json['phone'] as String? ?? '',
      projectName: json['project_name'] as String? ?? '',
      apartmentNumber: json['apartment_number'] as String? ?? json['apartment']?.toString() ?? '',
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      remainingAmount: remainingAmount,
      overdueAmount: overdueAmount,
      monthlyPayment: monthlyPayment,
      overdueDays: overdueDays,
      maxLateness: json['max_lateness'] as int? ?? overdueDays,
      paidPercentage: paidPercentage,
      currency: json['currency'] as String? ?? 'UZS',
      status: status,
      contractType: ContractType.fromString(json['type'] as String?),
      nextPaymentDate: _parseNullableDate(json['next_payment_date']),
      dueDate: _parseNullableDate(json['due_date']),
      signedAt: signedAt,
      assignedToId: json['assigned_to_id'] as int?,
      assignedToName: json['assigned_to'] as String?,
      installmentMonths: installmentMonths,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static DateTime? _parseNullableDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static int _monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  /// Get formatted total amount based on currency
  String get formattedTotalAmount {
    return _formatAmount(totalAmount);
  }

  /// Get formatted remaining amount based on currency
  String get formattedRemainingAmount {
    return _formatAmount(remainingAmount);
  }

  /// Get formatted overdue amount
  String get formattedOverdueAmount {
    return _formatAmount(overdueAmount);
  }

  /// Get formatted paid amount
  String get formattedPaidAmount {
    return _formatAmount(paidAmount);
  }

  /// Get formatted monthly payment
  String get formattedMonthlyPayment {
    return _formatAmount(monthlyPayment);
  }

  String _formatAmount(double amount) {
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

  /// Short format for cards (without UZS suffix)
  String get shortFormattedOverdueAmount {
    if (currency == 'USD') {
      return '\$${overdueAmount.toStringAsFixed(0)}';
    }
    if (overdueAmount >= 1000000000) {
      return '${(overdueAmount / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (overdueAmount >= 1000000) {
      return '${(overdueAmount / 1000000).toStringAsFixed(1)} mln';
    }
    return overdueAmount.toStringAsFixed(0);
  }

  /// Get severity level based on overdue days
  /// 0: < 7 days (green/mild)
  /// 1: 7-30 days (yellow/warning)
  /// 2: > 30 days (red/critical)
  int get severityLevel {
    if (overdueDays < 7) return 0;
    if (overdueDays <= 30) return 1;
    return 2;
  }

  /// Get formatted phone number for display
  String get formattedPhone {
    if (phoneNumber.length == 12 && phoneNumber.startsWith('998')) {
      return '+${phoneNumber.substring(0, 3)} ${phoneNumber.substring(3, 5)} ${phoneNumber.substring(5, 8)} ${phoneNumber.substring(8, 10)} ${phoneNumber.substring(10)}';
    }
    if (phoneNumber.length == 9) {
      return '+998 ${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 5)} ${phoneNumber.substring(5, 7)} ${phoneNumber.substring(7)}';
    }
    return phoneNumber;
  }

  /// Get formatted paid percentage string
  String get formattedPaidPercentage => '${paidPercentage.toStringAsFixed(0)}%';

  /// Get overdue days text
  String get overdueDaysText {
    if (overdueDays == 0) return "O'z vaqtida";
    return '$overdueDays kun kechikish';
  }

  /// Get status label in Uzbek
  String get statusLabel => status.label;

  Debt copyWith({
    String? id,
    int? contractId,
    String? contractNumber,
    int? clientId,
    String? clientName,
    String? phoneNumber,
    String? projectName,
    String? apartmentNumber,
    double? totalAmount,
    double? paidAmount,
    double? remainingAmount,
    double? overdueAmount,
    double? monthlyPayment,
    int? overdueDays,
    int? maxLateness,
    double? paidPercentage,
    String? currency,
    DebtStatus? status,
    ContractType? contractType,
    DateTime? nextPaymentDate,
    DateTime? dueDate,
    DateTime? signedAt,
    int? assignedToId,
    String? assignedToName,
    int? installmentMonths,
  }) {
    return Debt(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      contractNumber: contractNumber ?? this.contractNumber,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      projectName: projectName ?? this.projectName,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      overdueAmount: overdueAmount ?? this.overdueAmount,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      overdueDays: overdueDays ?? this.overdueDays,
      maxLateness: maxLateness ?? this.maxLateness,
      paidPercentage: paidPercentage ?? this.paidPercentage,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      contractType: contractType ?? this.contractType,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      dueDate: dueDate ?? this.dueDate,
      signedAt: signedAt ?? this.signedAt,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToName: assignedToName ?? this.assignedToName,
      installmentMonths: installmentMonths ?? this.installmentMonths,
    );
  }

  @override
  List<Object?> get props => [
        id,
        contractId,
        contractNumber,
        clientId,
        clientName,
        phoneNumber,
        projectName,
        apartmentNumber,
        totalAmount,
        paidAmount,
        remainingAmount,
        overdueAmount,
        monthlyPayment,
        overdueDays,
        maxLateness,
        paidPercentage,
        currency,
        status,
        contractType,
        nextPaymentDate,
        dueDate,
        signedAt,
        assignedToId,
        assignedToName,
        installmentMonths,
      ];
}

/// Paginated response for debts (contracts) list
class DebtsPaginatedResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Debt> results;

  const DebtsPaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory DebtsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    final results = <Debt>[];
    final rawResults = json['results'];
    if (rawResults is List) {
      for (final item in rawResults) {
        if (item is Map<String, dynamic>) {
          results.add(Debt.fromJson(item));
        }
      }
    }
    return DebtsPaginatedResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: results,
    );
  }
}
