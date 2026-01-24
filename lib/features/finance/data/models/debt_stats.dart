import 'package:equatable/equatable.dart';

/// Debt statistics model
class DebtStats extends Equatable {
  const DebtStats({
    required this.totalDebt,
    required this.overdueAmount,
    required this.paidThisMonth,
    required this.debtorsCount,
    this.overdueCount = 0,
    this.activeCount = 0,
  });

  final double totalDebt;
  final double overdueAmount;
  final double paidThisMonth;
  final int debtorsCount;
  final int overdueCount;
  final int activeCount;

  /// Factory for empty stats
  factory DebtStats.empty() {
    return const DebtStats(
      totalDebt: 0,
      overdueAmount: 0,
      paidThisMonth: 0,
      debtorsCount: 0,
      overdueCount: 0,
      activeCount: 0,
    );
  }

  /// Create from API JSON response
  factory DebtStats.fromJson(Map<String, dynamic> json) {
    return DebtStats(
      totalDebt: _parseDouble(json['total_debt'] ?? json['total_remaining']),
      overdueAmount: _parseDouble(json['overdue_amount'] ?? json['overdue_debt']),
      paidThisMonth: _parseDouble(json['paid_this_month']),
      debtorsCount: json['debtors_count'] as int? ?? json['total_debtors'] as int? ?? 0,
      overdueCount: json['overdue_count'] as int? ?? 0,
      activeCount: json['active_count'] as int? ?? 0,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  /// Get formatted total debt
  String get formattedTotalDebt {
    if (totalDebt >= 1000000000) {
      return '${(totalDebt / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (totalDebt >= 1000000) {
      return '${(totalDebt / 1000000).toStringAsFixed(0)} mln';
    }
    return totalDebt.toStringAsFixed(0);
  }

  /// Get formatted overdue amount
  String get formattedOverdueAmount {
    if (overdueAmount >= 1000000000) {
      return '${(overdueAmount / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (overdueAmount >= 1000000) {
      return '${(overdueAmount / 1000000).toStringAsFixed(0)} mln';
    }
    return overdueAmount.toStringAsFixed(0);
  }

  /// Get formatted paid this month
  String get formattedPaidThisMonth {
    if (paidThisMonth >= 1000000000) {
      return '${(paidThisMonth / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (paidThisMonth >= 1000000) {
      return '${(paidThisMonth / 1000000).toStringAsFixed(0)} mln';
    }
    return paidThisMonth.toStringAsFixed(0);
  }

  DebtStats copyWith({
    double? totalDebt,
    double? overdueAmount,
    double? paidThisMonth,
    int? debtorsCount,
    int? overdueCount,
    int? activeCount,
  }) {
    return DebtStats(
      totalDebt: totalDebt ?? this.totalDebt,
      overdueAmount: overdueAmount ?? this.overdueAmount,
      paidThisMonth: paidThisMonth ?? this.paidThisMonth,
      debtorsCount: debtorsCount ?? this.debtorsCount,
      overdueCount: overdueCount ?? this.overdueCount,
      activeCount: activeCount ?? this.activeCount,
    );
  }

  @override
  List<Object?> get props => [
        totalDebt,
        overdueAmount,
        paidThisMonth,
        debtorsCount,
        overdueCount,
        activeCount,
      ];
}
