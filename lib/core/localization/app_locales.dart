import 'package:flutter/material.dart';

const List<Locale> kSupportedLocales = [
  Locale('uz'),
  Locale('ru'),
  Locale('en'),
];

const Locale kFallbackLocale = Locale('uz');

String normalizeLocaleCode(String? code) {
  switch (code) {
    case 'uz':
    case 'ru':
    case 'en':
      return code!;
    case 'uz_latin':
    case 'uz_cyrillic':
      return 'uz';
    default:
      return kFallbackLocale.languageCode;
  }
}

Locale localeFromCode(String? code) {
  final normalized = normalizeLocaleCode(code);
  return kSupportedLocales.firstWhere(
    (locale) => locale.languageCode == normalized,
    orElse: () => kFallbackLocale,
  );
}
