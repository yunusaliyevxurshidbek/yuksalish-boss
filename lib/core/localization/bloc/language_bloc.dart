import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_locales.dart';
import '../language_prefs.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguagePrefs _prefs;

  LanguageBloc({required LanguagePrefs prefs})
      : _prefs = prefs,
        super(LanguageState(locale: localeFromCode(prefs.getSavedLocaleCode()))) {
    on<LanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    final locale = localeFromCode(event.localeCode);
    await _prefs.saveLocaleCode(locale.languageCode);
    emit(LanguageState(locale: locale));
  }
}
