part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final String localeCode;

  const LanguageChanged(this.localeCode);

  @override
  List<Object?> get props => [localeCode];
}
