import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_prefs.dart';

/// State class for theme management.
class ThemeState {
  final ThemeMode themeMode;
  final bool isDark;

  const ThemeState({
    required this.themeMode,
    required this.isDark,
  });

  factory ThemeState.light() => const ThemeState(
        themeMode: ThemeMode.light,
        isDark: false,
      );

  factory ThemeState.dark() => const ThemeState(
        themeMode: ThemeMode.dark,
        isDark: true,
      );

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isDark,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDark: isDark ?? this.isDark,
    );
  }
}

/// Cubit for managing app theme state globally.
class ThemeCubit extends Cubit<ThemeState> {
  final ThemePrefs _themePrefs;

  ThemeCubit({
    required ThemePrefs themePrefs,
  })  : _themePrefs = themePrefs,
        super(ThemeState.light());

  /// Initialize theme from saved preferences.
  Future<void> init() async {
    final isDark = await _themePrefs.getThemeMode();
    emit(isDark ? ThemeState.dark() : ThemeState.light());
  }

  /// Toggle between light and dark theme.
  Future<void> toggleTheme() async {
    final newIsDark = !state.isDark;
    await _themePrefs.saveThemeMode(newIsDark);
    emit(newIsDark ? ThemeState.dark() : ThemeState.light());
  }

  /// Set theme explicitly.
  Future<void> setDarkMode(bool isDark) async {
    if (state.isDark == isDark) return;
    await _themePrefs.saveThemeMode(isDark);
    emit(isDark ? ThemeState.dark() : ThemeState.light());
  }
}
