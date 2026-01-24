import 'package:flutter/material.dart';

/// Data class for filter chip with icon.
class FilterChipItem {
  /// Chip label.
  final String label;

  /// Optional icon.
  final IconData? icon;

  /// Optional count badge.
  final int? count;

  const FilterChipItem({
    required this.label,
    this.icon,
    this.count,
  });
}
