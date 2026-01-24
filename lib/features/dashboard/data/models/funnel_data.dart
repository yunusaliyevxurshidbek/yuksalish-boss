import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Funnel data model for sales pipeline visualization
class FunnelData extends Equatable {
  final String stage;
  final int count;
  final Color color;

  const FunnelData({
    required this.stage,
    required this.count,
    required this.color,
  });

  factory FunnelData.empty() => const FunnelData(
        stage: '',
        count: 0,
        color: Colors.grey,
      );

  FunnelData copyWith({
    String? stage,
    int? count,
    Color? color,
  }) {
    return FunnelData(
      stage: stage ?? this.stage,
      count: count ?? this.count,
      color: color ?? this.color,
    );
  }

  /// Calculate percentage based on total count
  double getPercentage(int totalCount) {
    if (totalCount == 0) return 0;
    return count / totalCount;
  }

  @override
  List<Object?> get props => [stage, count, color];
}
