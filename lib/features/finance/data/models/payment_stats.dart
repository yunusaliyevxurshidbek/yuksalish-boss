import 'package:equatable/equatable.dart';

/// Payment statistics model
class PaymentStats extends Equatable {
  const PaymentStats({
    required this.totalReceived,
    required this.receivedThisMonth,
    required this.pendingPayments,
    required this.pendingCount,
    required this.overduePayments,
    required this.overdueCount,
    required this.totalTransactions,
    this.paidPercentage = 0,
    this.pendingPercentage = 0,
    this.noInitialPercentage = 0,
  });

  final double totalReceived;
  final int receivedThisMonth;
  final double pendingPayments;
  final int pendingCount;
  final double overduePayments;
  final int overdueCount;
  final int totalTransactions;

  // For donut chart
  final double paidPercentage;
  final double pendingPercentage;
  final double noInitialPercentage;

  /// Factory for empty stats
  factory PaymentStats.empty() {
    return const PaymentStats(
      totalReceived: 0,
      receivedThisMonth: 0,
      pendingPayments: 0,
      pendingCount: 0,
      overduePayments: 0,
      overdueCount: 0,
      totalTransactions: 0,
      paidPercentage: 0,
      pendingPercentage: 0,
      noInitialPercentage: 0,
    );
  }

  /// Create from API JSON response
  factory PaymentStats.fromJson(Map<String, dynamic> json) {
    return PaymentStats(
      totalReceived: _parseDouble(json['total_received'] ?? json['total_amount']),
      receivedThisMonth: json['received_this_month'] as int? ?? json['payments_this_month'] as int? ?? 0,
      pendingPayments: _parseDouble(json['pending_payments'] ?? json['pending_amount']),
      pendingCount: json['pending_count'] as int? ?? 0,
      overduePayments: _parseDouble(json['overdue_payments'] ?? json['overdue_amount']),
      overdueCount: json['overdue_count'] as int? ?? 0,
      totalTransactions: json['total_transactions'] as int? ?? json['total_count'] as int? ?? 0,
      paidPercentage: _parseDouble(json['paid_percentage']),
      pendingPercentage: _parseDouble(json['pending_percentage']),
      noInitialPercentage: _parseDouble(json['no_initial_percentage']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  /// Get formatted total received
  String get formattedTotalReceived {
    if (totalReceived >= 1000000000) {
      return '${(totalReceived / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (totalReceived >= 1000000) {
      return '${(totalReceived / 1000000).toStringAsFixed(0)} mln';
    }
    return totalReceived.toStringAsFixed(0);
  }

  /// Get formatted pending payments
  String get formattedPendingPayments {
    if (pendingPayments >= 1000000000) {
      return '${(pendingPayments / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (pendingPayments >= 1000000) {
      return '${(pendingPayments / 1000000).toStringAsFixed(0)} mln';
    }
    return pendingPayments.toStringAsFixed(0);
  }

  /// Get formatted overdue payments
  String get formattedOverduePayments {
    if (overduePayments >= 1000000000) {
      return '${(overduePayments / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (overduePayments >= 1000000) {
      return '${(overduePayments / 1000000).toStringAsFixed(0)} mln';
    }
    return overduePayments.toStringAsFixed(0);
  }

  PaymentStats copyWith({
    double? totalReceived,
    int? receivedThisMonth,
    double? pendingPayments,
    int? pendingCount,
    double? overduePayments,
    int? overdueCount,
    int? totalTransactions,
    double? paidPercentage,
    double? pendingPercentage,
    double? noInitialPercentage,
  }) {
    return PaymentStats(
      totalReceived: totalReceived ?? this.totalReceived,
      receivedThisMonth: receivedThisMonth ?? this.receivedThisMonth,
      pendingPayments: pendingPayments ?? this.pendingPayments,
      pendingCount: pendingCount ?? this.pendingCount,
      overduePayments: overduePayments ?? this.overduePayments,
      overdueCount: overdueCount ?? this.overdueCount,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      paidPercentage: paidPercentage ?? this.paidPercentage,
      pendingPercentage: pendingPercentage ?? this.pendingPercentage,
      noInitialPercentage: noInitialPercentage ?? this.noInitialPercentage,
    );
  }

  @override
  List<Object?> get props => [
        totalReceived,
        receivedThisMonth,
        pendingPayments,
        pendingCount,
        overduePayments,
        overdueCount,
        totalTransactions,
        paidPercentage,
        pendingPercentage,
        noInitialPercentage,
      ];
}
