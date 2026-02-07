import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'core/constants/app_lock_constants.dart';
import 'core/network/csrf_token_provider.dart';
import 'core/network/dio_settings.dart';
import 'core/localization/bloc/language_bloc.dart';
import 'core/localization/language_prefs.dart';
import 'core/services/crypto_service.dart';
import 'core/services/version_check_service.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_prefs.dart';
import 'features/app_lock/data/datasources/local/app_lock_local_datasource.dart';
import 'features/app_lock/data/datasources/local/biometric_datasource.dart';
import 'features/auth/data/datasources/remote/company_remote_datasource.dart';
import 'features/auth/data/datasources/remote/forgot_password_remote_datasource.dart';
import 'features/auth/data/datasources/remote/login_remote_datasource.dart';
import 'features/auth/data/datasources/remote/logout_remote_datasource.dart';
import 'features/auth/data/datasources/remote/reset_password_remote_datasource.dart';
import 'features/auth/data/datasources/remote/set_password_remote_datasource.dart';
import 'features/auth/data/datasources/remote/register_remote_datasource.dart';
import 'features/auth/data/datasources/remote/verify_otp_remote_datasource.dart';
import 'features/app_lock/data/repositories/app_lock_repository_impl.dart';
import 'features/auth/data/repositories/register_repository_impl.dart';
import 'features/auth/data/repositories/forgot_password_repository_impl.dart';
import 'features/auth/data/repositories/login_repository_impl.dart';
import 'features/auth/data/repositories/logout_repository_impl.dart';
import 'features/auth/data/repositories/reset_password_repository_impl.dart';
import 'features/auth/data/repositories/set_password_repository_impl.dart';
import 'features/auth/data/repositories/verify_otp_repository_impl.dart';
import 'features/app_lock/domain/repositories/app_lock_repository.dart';
import 'features/auth/domain/repositories/register_repository.dart';
import 'features/auth/domain/repositories/forgot_password_repository.dart';
import 'features/auth/domain/repositories/login_repository.dart';
import 'features/auth/domain/repositories/logout_repository.dart';
import 'features/auth/domain/repositories/reset_password_repository.dart';
import 'features/auth/domain/repositories/set_password_repository.dart';
import 'features/auth/domain/repositories/verify_otp_repository.dart';
import 'features/app_lock/domain/usecases/authenticate_biometric.dart';
import 'features/app_lock/domain/usecases/check_biometrics_available.dart';
import 'features/app_lock/domain/usecases/clear_app_lock_data.dart';
import 'features/app_lock/domain/usecases/get_lock_status.dart';
import 'features/app_lock/domain/usecases/record_failed_attempt.dart';
import 'features/app_lock/domain/usecases/setup_pin.dart';
import 'features/app_lock/domain/usecases/toggle_biometric.dart';
import 'features/app_lock/domain/usecases/verify_pin.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/reset_password.dart';
import 'features/auth/domain/usecases/send_register_code.dart';
import 'features/auth/domain/usecases/send_forgot_password_code.dart';
import 'features/auth/domain/usecases/set_password.dart';
import 'features/auth/domain/usecases/verify_otp.dart';
import 'features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import 'features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'features/auth/presentation/bloc/login/login_cubit.dart';
import 'features/auth/presentation/bloc/logout/logout_cubit.dart';
import 'features/auth/presentation/bloc/otp/verify_otp_cubit.dart';
import 'features/auth/presentation/bloc/reset_password/reset_password_cubit.dart';
import 'features/auth/presentation/bloc/register/register_cubit.dart';
import 'features/auth/presentation/bloc/registration_config/registration_config_cubit.dart';
import 'features/auth/presentation/bloc/set_password/set_password_cubit.dart';

// Dashboard Feature
import 'features/dashboard/data/datasources/crm_stats_remote_datasource.dart';
import 'features/dashboard/data/datasources/overdue_payments_remote_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dashboard/presentation/bloc/funnel_analysis_cubit.dart';
import 'features/dashboard/presentation/bloc/sales_dynamics_cubit.dart';

// Analytics Feature
import 'features/analytics/data/datasources/analytics_cache.dart';
import 'features/analytics/data/datasources/analytics_remote_datasource.dart';
import 'features/analytics/data/repositories/analytics_repository.dart';
import 'features/analytics/presentation/bloc/analytics_bloc.dart';

// Finance Feature
import 'features/finance/data/datasources/finance_remote_datasource.dart';
import 'features/finance/data/repositories/finance_repository.dart';
import 'features/finance/presentation/bloc/finance_bloc.dart';

// Approvals Feature
import 'features/approvals/data/repositories/approvals_repository.dart';
import 'features/approvals/presentation/bloc/approvals_cubit.dart';

// Notifications Feature
import 'features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'features/notifications/data/repositories/notifications_repository.dart';
import 'features/notifications/presentation/bloc/notifications_cubit.dart';

// Main Shell Feature
import 'features/main_shell/presentation/bloc/main_shell_cubit.dart';

// Profile Feature
import 'features/profile/data/datasources/profile_edit_remote_datasource.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository.dart';
import 'features/profile/data/repositories/profile_edit_repository.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/profile/presentation/bloc/profile_edit_bloc.dart';

// Leads Feature
import 'features/leads/data/datasources/leads_remote_datasource.dart';
import 'features/leads/data/repositories/leads_repository.dart';
import 'features/leads/presentation/bloc/leads_cubit.dart';
import 'features/leads/presentation/bloc/lead_details_cubit.dart';

// Revenue Feature
import 'features/revenue/data/datasources/contracts_remote_datasource.dart';
import 'features/revenue/presentation/bloc/revenue_details_cubit.dart';

// Sold Apartments Feature
import 'features/sold_apartments/data/datasources/builder_stats_remote_datasource.dart';
import 'features/sold_apartments/data/datasources/apartments_remote_datasource.dart';
import 'features/sold_apartments/presentation/bloc/sold_apartments_cubit.dart';

// Projects Feature
import 'features/projects/data/datasources/projects_remote_datasource.dart';
import 'features/projects/data/repositories/projects_repository.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';

// Devices Feature
import 'features/devices/data/datasources/device_remote_datasource.dart';
import 'features/devices/data/repositories/device_repository_impl.dart';
import 'features/devices/data/services/device_info_service.dart';
import 'features/devices/domain/repositories/device_repository.dart';
import 'features/devices/domain/usecases/get_user_devices.dart';
import 'features/devices/domain/usecases/logout_all_devices.dart';
import 'features/devices/domain/usecases/register_device.dart';
import 'features/devices/domain/usecases/terminate_session.dart';
import 'features/devices/presentation/bloc/devices_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // ═══════════════════════════════════════════════════════════════════════════
  // THEME FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<ThemePrefs>(() => ThemePrefs());
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(themePrefs: getIt<ThemePrefs>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LOCALIZATION FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<LanguagePrefs>(() => LanguagePrefs());
  getIt.registerLazySingleton<LanguageBloc>(
    () => LanguageBloc(prefs: getIt<LanguagePrefs>()),
  );

  final baseUrl = AppConstants.baseUrl.endsWith('/')
      ? AppConstants.baseUrl
      : '${AppConstants.baseUrl}/';

  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        responseType: ResponseType.json,
        headers: const <String, dynamic>{
          'Accept': 'application/json',
        },
      ),
    ),
    instanceName: 'csrf',
  );

  getIt.registerLazySingleton<CsrfTokenProvider>(
    () => CsrfTokenProvider(getIt<Dio>(instanceName: 'csrf')),
  );

  getIt.registerLazySingleton<DioSettings>(
    () => DioSettings(
      csrfTokenProvider: getIt<CsrfTokenProvider>(),
    ),
  );
  getIt.registerLazySingleton<Dio>(() => getIt<DioSettings>().client);

  // ═══════════════════════════════════════════════════════════════════════════
  // VERSION CHECK SERVICE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<VersionCheckService>(
    () => VersionCheckService(getIt<Dio>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH FEATURE - COMPANY
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(getIt<Dio>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH FEATURE - LOGIN
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      remoteDataSource: getIt<LoginRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<LoginUser>(
    () => LoginUser(getIt<LoginRepository>()),
  );
  getIt.registerFactory(
    () => LoginCubit(
      getIt<LoginUser>(),
      getIt<CompanyRemoteDataSource>(),
      getIt<DeviceInfoService>(),
      getIt<RegisterDevice>(),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH FEATURE - REGISTER
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(
      remoteDataSource: getIt<RegisterRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<SendRegisterCode>(
    () => SendRegisterCode(getIt<RegisterRepository>()),
  );
  getIt.registerFactory(
    () => RegisterCubit(getIt<SendRegisterCode>()),
  );
  getIt.registerFactory(
    () => RegistrationConfigCubit(getIt<Dio>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH FEATURE - LOGOUT
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<LogoutRemoteDataSource>(
    () => LogoutRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<LogoutRepository>(
    () => LogoutRepositoryImpl(
      remoteDataSource: getIt<LogoutRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<LogoutUser>(
    () => LogoutUser(getIt<LogoutRepository>()),
  );
  getIt.registerFactory(
    () => LogoutCubit(getIt<LogoutUser>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH FEATURE - VERIFY OTP
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<VerifyOtpRemoteDataSource>(
    () => VerifyOtpRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<VerifyOtpRepository>(
    () => VerifyOtpRepositoryImpl(
      remoteDataSource: getIt<VerifyOtpRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<VerifyOtp>(
    () => VerifyOtp(getIt<VerifyOtpRepository>()),
  );
  getIt.registerFactory(
    () => VerifyOtpCubit(getIt<VerifyOtp>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH FEATURE - SET PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<SetPasswordRemoteDataSource>(
    () => SetPasswordRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<SetPasswordRepository>(
    () => SetPasswordRepositoryImpl(
      remoteDataSource: getIt<SetPasswordRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<SetPassword>(
    () => SetPassword(getIt<SetPasswordRepository>()),
  );
  getIt.registerFactory(
    () => SetPasswordCubit(getIt<SetPassword>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH FEATURE - FORGOT PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(
      remoteDataSource: getIt<ForgotPasswordRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<SendForgotPasswordCode>(
    () => SendForgotPasswordCode(getIt<ForgotPasswordRepository>()),
  );
  getIt.registerFactory(
    () => ForgotPasswordCubit(getIt<SendForgotPasswordCode>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH FEATURE - RESET PASSWORD
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<ResetPasswordRemoteDataSource>(
    () => ResetPasswordRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ResetPasswordRepository>(
    () => ResetPasswordRepositoryImpl(
      remoteDataSource: getIt<ResetPasswordRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(getIt<ResetPasswordRepository>()),
  );
  getIt.registerFactory(
    () => ResetPasswordCubit(getIt<ResetPasswordUseCase>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // APP LOCK FEATURE
  // ═══════════════════════════════════════════════════════════════════════════

  // 1. External Dependencies
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  );

  getIt.registerLazySingleton<LocalAuthentication>(
    () => LocalAuthentication(),
  );

  // 2. Core Services
  getIt.registerLazySingleton<CryptoService>(
    () => CryptoService(
      iterations: AppLockConstants.pbkdf2Iterations,
      saltLength: AppLockConstants.saltLength,
      hashLength: AppLockConstants.hashLength,
    ),
  );

  // 3. Data Sources
  getIt.registerLazySingleton<AppLockLocalDataSource>(
    () => AppLockLocalDataSourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );

  getIt.registerLazySingleton<BiometricDataSource>(
    () => BiometricDataSourceImpl(localAuth: getIt<LocalAuthentication>()),
  );

  // 4. Repository
  getIt.registerLazySingleton<AppLockRepository>(
    () => AppLockRepositoryImpl(
      localDataSource: getIt<AppLockLocalDataSource>(),
      biometricDataSource: getIt<BiometricDataSource>(),
      cryptoService: getIt<CryptoService>(),
    ),
  );

  // 5. Use Cases
  getIt.registerLazySingleton<SetupPin>(
    () => SetupPin(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton<VerifyPin>(
    () => VerifyPin(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton<ToggleBiometric>(
    () => ToggleBiometric(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton<AuthenticateBiometric>(
    () => AuthenticateBiometric(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton<CheckBiometricsAvailable>(
    () => CheckBiometricsAvailable(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton<GetLockStatus>(
    () => GetLockStatus(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton<RecordFailedAttempt>(
    () => RecordFailedAttempt(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton<ClearAppLockData>(
    () => ClearAppLockData(getIt<AppLockRepository>()),
  );

  // 6. BLoC (Singleton - manages global app lock state)
  getIt.registerLazySingleton<AppLockBloc>(
    () => AppLockBloc(
      setupPin: getIt<SetupPin>(),
      verifyPin: getIt<VerifyPin>(),
      toggleBiometric: getIt<ToggleBiometric>(),
      authenticateBiometric: getIt<AuthenticateBiometric>(),
      checkBiometricsAvailable: getIt<CheckBiometricsAvailable>(),
      getLockStatus: getIt<GetLockStatus>(),
      recordFailedAttempt: getIt<RecordFailedAttempt>(),
      clearAppLockData: getIt<ClearAppLockData>(),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LEADS FEATURE (must be before Dashboard since Dashboard depends on it)
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<LeadsRemoteDataSource>(
    () => LeadsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<LeadsRepository>(
    () => LeadsRepositoryImpl(getIt<LeadsRemoteDataSource>()),
  );
  getIt.registerFactory<LeadsCubit>(
    () => LeadsCubit(repository: getIt<LeadsRepository>()),
  );
  getIt.registerFactory<LeadDetailsCubit>(
    () => LeadDetailsCubit(repository: getIt<LeadsRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DASHBOARD FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<CrmStatsRemoteDataSource>(
    () => CrmStatsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(getIt<CrmStatsRemoteDataSource>()),
  );
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(repository: getIt<DashboardRepository>()),
  );
  getIt.registerFactory<FunnelAnalysisCubit>(
    () => FunnelAnalysisCubit(statsDataSource: getIt<CrmStatsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<OverduePaymentsRemoteDataSource>(
    () => OverduePaymentsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerFactory<SalesDynamicsCubit>(
    () => SalesDynamicsCubit(
      crmStatsDataSource: getIt<CrmStatsRemoteDataSource>(),
      builderStatsDataSource: getIt<BuilderStatsRemoteDataSource>(),
      overduePaymentsDataSource: getIt<OverduePaymentsRemoteDataSource>(),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // REVENUE FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<ContractsRemoteDataSource>(
    () => ContractsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerFactory<RevenueDetailsCubit>(
    () => RevenueDetailsCubit(
      statsDataSource: getIt<CrmStatsRemoteDataSource>(),
      contractsDataSource: getIt<ContractsRemoteDataSource>(),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SOLD APARTMENTS FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<BuilderStatsRemoteDataSource>(
    () => BuilderStatsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ApartmentsRemoteDataSource>(
    () => ApartmentsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerFactory<SoldApartmentsCubit>(
    () => SoldApartmentsCubit(
      crmStatsDataSource: getIt<CrmStatsRemoteDataSource>(),
      builderStatsDataSource: getIt<BuilderStatsRemoteDataSource>(),
      apartmentsDataSource: getIt<ApartmentsRemoteDataSource>(),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ANALYTICS FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<AnalyticsCache>(() => AnalyticsCache());
  getIt.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => AnalyticsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      remoteDataSource: getIt<AnalyticsRemoteDataSource>(),
      cache: getIt<AnalyticsCache>(),
    ),
  );
  getIt.registerFactory<AnalyticsBloc>(
    () => AnalyticsBloc(repository: getIt<AnalyticsRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // FINANCE FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<FinanceRemoteDataSource>(
    () => FinanceRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(getIt<FinanceRemoteDataSource>()),
  );
  getIt.registerFactory<FinanceBloc>(
    () => FinanceBloc(repository: getIt<FinanceRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // APPROVALS FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<ApprovalsRepository>(
    () => ApprovalsRepositoryImpl(),
  );
  getIt.registerFactory<ApprovalsCubit>(
    () => ApprovalsCubit(repository: getIt<ApprovalsRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTIFICATIONS FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: getIt<NotificationsRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<NotificationsCubit>(
    () => NotificationsCubit(repository: getIt<NotificationsRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN SHELL FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<MainShellCubit>(
    () => MainShellCubit(),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  // Profile Remote Data Source
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Profile Repository
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<ProfileRemoteDataSource>(),
    ),
  );

  // Profile Cubit (singleton to share state across screens)
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(repository: getIt<ProfileRepository>()),
  );

  // Profile Edit (for detailed profile editing)
  getIt.registerLazySingleton<ProfileEditRemoteDataSource>(
    () => ProfileEditRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProfileEditRepository>(
    () => ProfileEditRepositoryImpl(
      remoteDataSource: getIt<ProfileEditRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<ProfileEditBloc>(
    () => ProfileEditBloc(
      repository: getIt<ProfileEditRepository>(),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // PROJECTS FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  getIt.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(getIt<ProjectsRemoteDataSource>()),
  );
  getIt.registerFactory<ProjectsBloc>(
    () => ProjectsBloc(repository: getIt<ProjectsRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DEVICES FEATURE
  // ═══════════════════════════════════════════════════════════════════════════
  // Device Info Service (singleton for persistent device ID)
  getIt.registerLazySingleton<DeviceInfoService>(
    () => DeviceInfoService(),
  );

  // Data Source
  getIt.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(getIt<Dio>()),
  );

  // Repository
  getIt.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      remoteDataSource: getIt<DeviceRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<RegisterDevice>(
    () => RegisterDevice(getIt<DeviceRepository>()),
  );
  getIt.registerLazySingleton<GetUserDevices>(
    () => GetUserDevices(getIt<DeviceRepository>()),
  );
  getIt.registerLazySingleton<TerminateSession>(
    () => TerminateSession(getIt<DeviceRepository>()),
  );
  getIt.registerLazySingleton<LogoutAllDevices>(
    () => LogoutAllDevices(getIt<DeviceRepository>()),
  );

  // BLoC (factory - new instance per screen)
  getIt.registerFactory<DevicesBloc>(
    () => DevicesBloc(
      getUserDevices: getIt<GetUserDevices>(),
      terminateSession: getIt<TerminateSession>(),
      logoutAllDevices: getIt<LogoutAllDevices>(),
      registerDevice: getIt<RegisterDevice>(),
      deviceInfoService: getIt<DeviceInfoService>(),
    ),
  );

}
