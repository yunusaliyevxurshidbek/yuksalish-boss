import 'package:equatable/equatable.dart';

/// Contracts count data for bar charts
class ContractsData extends Equatable {
  /// Month abbreviation (e.g., "Yan", "Fev")
  final String month;

  /// Number of contracts signed
  final int count;

  /// Revenue from contracts in UZS (optional)
  final double? revenue;

  const ContractsData({
    required this.month,
    required this.count,
    this.revenue,
  });

  /// Format revenue in millions
  String? get formattedRevenue {
    if (revenue == null) return null;
    if (revenue! >= 1000000000) {
      return '${(revenue! / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (revenue! >= 1000000) {
      return '${(revenue! / 1000000).toStringAsFixed(1)} mln';
    }
    return revenue!.toStringAsFixed(0);
  }

  ContractsData copyWith({
    String? month,
    int? count,
    double? revenue,
  }) {
    return ContractsData(
      month: month ?? this.month,
      count: count ?? this.count,
      revenue: revenue ?? this.revenue,
    );
  }

  @override
  List<Object?> get props => [month, count, revenue];
}
