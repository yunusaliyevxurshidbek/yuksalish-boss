import 'package:equatable/equatable.dart';

/// Sales trend data for line charts
class SalesTrend extends Equatable {
  /// Month abbreviation (e.g., "Yan", "Fev")
  final String month;

  /// Sales amount in UZS
  final double amount;

  /// Number of sales
  final int count;

  const SalesTrend({
    required this.month,
    required this.amount,
    required this.count,
  });

  /// Format amount in millions/billions
  String get formattedAmount {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} mln';
    }
    return amount.toStringAsFixed(0);
  }

  SalesTrend copyWith({
    String? month,
    double? amount,
    int? count,
  }) {
    return SalesTrend(
      month: month ?? this.month,
      amount: amount ?? this.amount,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [month, amount, count];
}
