part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState({required this.locale});

  String get localeCode => locale.languageCode;

  @override
  List<Object?> get props => [localeCode];
}
