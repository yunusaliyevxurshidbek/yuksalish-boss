import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Analytics color palette - now references global AppColors for consistency.
/// This class acts as an alias layer to maintain backward compatibility
/// while using the unified color palette.
class AnalyticsColors {
  AnalyticsColors._();

  static const Color primary = AppColors.primary;
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
  static const Color danger = AppColors.error;
  static const Color info = AppColors.info;
  static const Color available = AppColors.chartBlue;

  static const Color background = AppColors.background;
  static const Color card = AppColors.surface;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textMuted = AppColors.textTertiary;
  static const Color border = AppColors.border;
}

const List<String> uzMonthNames = [
  'Yan',
  'Fev',
  'Mar',
  'Apr',
  'May',
  'Iyn',
  'Iyl',
  'Avg',
  'Sen',
  'Okt',
  'Noy',
  'Dek',
];

const Map<String, String> leadSourceLabels = {
  'instagram': 'Instagram',
  'website': 'Veb-sayt',
  'telegram': 'Telegram',
  'call': "Telefon qo'ng'irog'i",
  'referral': 'Tavsiya',
  'walk_in': 'Keldi',
  'other': 'Boshqa',
};

const Map<String, String> leadSourceTranslationKeys = {
  'instagram': 'leads_source_instagram',
  'website': 'leads_source_website',
  'telegram': 'leads_source_telegram',
  'call': 'leads_source_call',
  'referral': 'leads_source_referral',
  'walk_in': 'leads_source_walk_in',
  'other': 'leads_source_other',
};

const Map<String, Color> leadSourceColors = {
  'instagram': Color(0xFFE1306C),
  'website': AppColors.primary,
  'telegram': Color(0xFF0088CC),
  'call': AppColors.info,
  'referral': AppColors.success,
  'walk_in': AppColors.warning,
  'other': AppColors.chartPurple,
};

String formatCurrency(num value, {String currency = 'UZS'}) {
  if (currency.toUpperCase() == 'USD') {
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
    return '\$${value.toStringAsFixed(0)}';
  }

  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(1)} mlrd UZS';
  }
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)} mln UZS';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)} ming UZS';
  }
  return '${value.toStringAsFixed(0)} UZS';
}

String formatChartCurrency(num value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(1)} mlrd';
  }
  if (value >= 1000000) {
    return '${(value / 1000000).round()} mln';
  }
  if (value >= 1000) {
    return '${(value / 1000).round()} ming';
  }
  return value.toStringAsFixed(0);
}
