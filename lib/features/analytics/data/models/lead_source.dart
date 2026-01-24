import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Represents a lead source with count and percentage
class LeadSource extends Equatable {
  /// Source name (e.g., "Telegram", "Instagram")
  final String name;

  /// Number of leads from this source
  final int count;

  /// Percentage of total leads (0-100)
  final double percentage;

  /// Color for chart representation
  final Color color;

  const LeadSource({
    required this.name,
    required this.count,
    required this.percentage,
    required this.color,
  });

  /// Calculate percentage from count and total
  factory LeadSource.fromCount({
    required String name,
    required int count,
    required int totalCount,
    required Color color,
  }) {
    final percentage = totalCount > 0 ? (count / totalCount) * 100 : 0.0;
    return LeadSource(
      name: name,
      count: count,
      percentage: percentage,
      color: color,
    );
  }

  /// Format percentage with symbol
  String get formattedPercentage => '${percentage.toStringAsFixed(0)}%';

  LeadSource copyWith({
    String? name,
    int? count,
    double? percentage,
    Color? color,
  }) {
    return LeadSource(
      name: name ?? this.name,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [name, count, percentage, color];
}
