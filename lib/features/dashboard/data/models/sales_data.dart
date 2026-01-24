import 'package:equatable/equatable.dart';

/// Sales data model for chart visualization
class SalesData extends Equatable {
  final String month;
  final int year;
  final double amount;
  final int count;

  const SalesData({
    required this.month,
    required this.year,
    required this.amount,
    required this.count,
  });

  factory SalesData.empty() => const SalesData(
        month: '',
        year: 0,
        amount: 0,
        count: 0,
      );

  SalesData copyWith({
    String? month,
    int? year,
    double? amount,
    int? count,
  }) {
    return SalesData(
      month: month ?? this.month,
      year: year ?? this.year,
      amount: amount ?? this.amount,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [month, year, amount, count];
}
