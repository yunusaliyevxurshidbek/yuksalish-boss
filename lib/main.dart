import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:yuksalish_mobile/firebase_options.dart';
import 'core/localization/app_locales.dart';
import 'core/localization/bloc/language_bloc.dart';
import 'core/localization/language_prefs.dart';
import 'core/router/app_router.dart';
import 'core/services/my_shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import 'injection_container.dart' as di;
import 'presentation/managers/app_lock_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('uz', null);
  await MySharedPreferences.init();
  await di.init();

  final themeCubit = di.getIt<ThemeCubit>();
  await themeCubit.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  final languagePrefs = di.getIt<LanguagePrefs>();
  final startLocale = localeFromCode(languagePrefs.getSavedLocaleCode());

  runApp(
    EasyLocalization(
      supportedLocales: kSupportedLocales,
      path: 'assets/translations',
      fallbackLocale: kFallbackLocale,
      startLocale: startLocale,
      saveLocale: false,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appLockBloc = di.getIt<AppLockBloc>();
    final themeCubit = di.getIt<ThemeCubit>();
    final languageBloc = di.getIt<LanguageBloc>();

    return ScreenUtilInit(
      designSize: const Size(430, 960),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppLockBloc>.value(value: appLockBloc),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<LanguageBloc>.value(value: languageBloc),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return BlocListener<LanguageBloc, LanguageState>(
              listenWhen: (previous, current) =>
                  previous.locale != current.locale,
              listener: (context, state) {
                if (context.locale != state.locale) {
                  context.setLocale(state.locale);
                }
              },
              child: AppLockManager(
                router: router,
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: router,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeState.themeMode,
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



