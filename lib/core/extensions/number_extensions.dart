import 'package:intl/intl.dart';

/// Number formatting extensions for currency and percentage display.
///
/// Provides Uzbek locale formatting for construction company financial data.
///
/// Usage:
/// ```dart
/// 1234567.formatted     // "1 234 567"
/// 1234567.short         // "1.23 mln"
/// 1234567.currency      // "1 234 567 UZS"
/// 0.15.percentage       // "+15%"
/// (-0.08).percentage    // "-8%"
/// ```
extension NumberFormatting on num {
  /// Format number with space separators (Uzbek/European style)
  ///
  /// Example: 1234567 -> "1 234 567"
  String get formatted {
    final formatter = NumberFormat('#,###', 'uz_UZ');
    return formatter.format(this).replaceAll(',', ' ');
  }

  /// Format large numbers in shortened form
  ///
  /// Examples:
  /// - 1234567 -> "1.23 mln"
  /// - 1234567890 -> "1.23 mlrd"
  /// - 1234 -> "1 234"
  String get short {
    if (abs() >= 1000000000) {
      final value = this / 1000000000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)} mlrd';
    } else if (abs() >= 1000000) {
      final value = this / 1000000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)} mln';
    } else if (abs() >= 1000) {
      final value = this / 1000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} ming';
    }
    return formatted;
  }

  /// Format as currency with UZS suffix
  ///
  /// Example: 1234567 -> "1 234 567 UZS"
  String get currency => '$formatted UZS';

  /// Format as currency in shortened form
  ///
  /// Example: 1234567 -> "1.23 mln UZS"
  String get currencyShort => '$short UZS';

  /// Format as percentage with sign indicator
  ///
  /// Examples:
  /// - 0.15 -> "+15%"
  /// - -0.08 -> "-8%"
  /// - 1.5 -> "+150%" (if value > 1, treated as decimal)
  /// - 15 -> "+15%" (if value > 1, treated as whole percent)
  String get percentage {
    final percent = this > 1 || this < -1 ? this : this * 100;
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%';
  }

  /// Format as percentage without sign
  ///
  /// Example: 0.75 -> "75%"
  String get percentageUnsigned {
    final percent = this > 1 || this < -1 ? abs() : (abs() * 100);
    return '${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%';
  }

  /// Format as square meters
  ///
  /// Example: 1250 -> "1 250 m²"
  String get sqMeters => '$formatted m²';

  /// Format as count with appropriate suffix
  ///
  /// Examples:
  /// - 1 -> "1 ta"
  /// - 15 -> "15 ta"
  String get count => '$formatted ta';

  /// Format as days
  ///
  /// Example: 45 -> "45 kun"
  String get days => '$formatted kun';

  /// Format as months
  ///
  /// Example: 12 -> "12 oy"
  String get months => '$formatted oy';

  /// Format decimal with specific precision
  ///
  /// Example: 3.14159.withPrecision(2) -> "3.14"
  String withPrecision(int digits) => toStringAsFixed(digits);

  /// Format as compact currency for charts/limited space
  ///
  /// Examples:
  /// - 1500000 -> "1.5M"
  /// - 2300000000 -> "2.3B"
  String get compactCurrency {
    if (abs() >= 1000000000) {
      return '${(this / 1000000000).toStringAsFixed(1)}B';
    } else if (abs() >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (abs() >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}

/// Integer-specific formatting extensions
extension IntFormatting on int {
  /// Format with leading zeros
  ///
  /// Example: 5.padLeft(3) -> "005"
  String padLeft(int width, [String padding = '0']) =>
      toString().padLeft(width, padding);

  /// Format as ordinal number
  ///
  /// Example: 1 -> "1-chi", 2 -> "2-chi"
  String get ordinal => '$this-chi';

  /// Format as ranking position
  ///
  /// Example: 1 -> "#1", 15 -> "#15"
  String get rank => '#$this';
}

/// Double-specific formatting extensions
extension DoubleFormatting on double {
  /// Round to specific decimal places and format
  ///
  /// Example: 3.14159.roundTo(2) -> 3.14
  double roundTo(int places) {
    var mod = 1.0;
    for (var i = 0; i < places; i++) {
      mod *= 10;
    }
    return (this * mod).round() / mod;
  }

  /// Check if value is effectively zero (within tolerance)
  bool get isEffectivelyZero => abs() < 0.0001;
}
