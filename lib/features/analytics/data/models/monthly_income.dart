import 'package:equatable/equatable.dart';

/// Monthly income and expenses data for charts
class MonthlyIncome extends Equatable {
  /// Month abbreviation (e.g., "Yan", "Fev")
  final String month;

  /// Income amount in UZS
  final double income;

  /// Expenses amount in UZS
  final double expenses;

  const MonthlyIncome({
    required this.month,
    required this.income,
    required this.expenses,
  });

  /// Net income (income - expenses)
  double get netIncome => income - expenses;

  /// Format income in millions
  String get formattedIncome {
    if (income >= 1000000000) {
      return '${(income / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (income >= 1000000) {
      return '${(income / 1000000).toStringAsFixed(1)} mln';
    }
    return income.toStringAsFixed(0);
  }

  /// Format expenses in millions
  String get formattedExpenses {
    if (expenses >= 1000000000) {
      return '${(expenses / 1000000000).toStringAsFixed(1)} mlrd';
    } else if (expenses >= 1000000) {
      return '${(expenses / 1000000).toStringAsFixed(1)} mln';
    }
    return expenses.toStringAsFixed(0);
  }

  MonthlyIncome copyWith({
    String? month,
    double? income,
    double? expenses,
  }) {
    return MonthlyIncome(
      month: month ?? this.month,
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
    );
  }

  @override
  List<Object?> get props => [month, income, expenses];
}
