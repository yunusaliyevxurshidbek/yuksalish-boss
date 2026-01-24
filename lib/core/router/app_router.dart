import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../enums/otp_flow.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/approvals/presentation/screens/approval_detail_screen.dart';
import '../../features/approvals/presentation/screens/approvals_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/forgot_password.dart';
import '../../features/auth/presentation/screens/login/login_page.dart';
import '../../features/auth/presentation/screens/otp/otp_page.dart';
import '../../features/auth/presentation/screens/pin_code/pin_code.dart';
import '../../features/auth/presentation/screens/reset_password/reset_password.dart';
import '../../features/auth/presentation/screens/set_up_user_info/set_up_user_info.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/funnel_analysis_page.dart';
import '../../features/dashboard/presentation/screens/sales_dynamics_page.dart';
import '../../features/finance/presentation/screens/all_payments_screen.dart';
import '../../features/finance/presentation/screens/finance_screen.dart';
import '../../features/main_shell/main_shell_screen.dart';
import '../../features/notifications/notifications.dart';
import '../../features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import '../../features/profile/presentation/bloc/profile_cubit.dart';
import '../../features/profile/presentation/screens/about_screen.dart';
import '../../features/profile/presentation/screens/company_info_screen.dart';
import '../../features/profile/presentation/screens/devices_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/language_screen.dart';
import '../../features/profile/presentation/screens/profile_details_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/session_timeout_screen.dart';
import '../../features/profile/presentation/screens/support_screen.dart';
import '../../features/projects/presentation/screens/apartment_detail_screen.dart';
import '../../features/projects/presentation/screens/project_detail_screen_new.dart';
import '../../features/projects/presentation/screens/project_details_screen.dart';
import '../../features/projects/presentation/screens/projects_page.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/onboarding/onboarding.dart';
import '../../features/leads/presentation/screens/leads_screen.dart';
import '../../features/leads/presentation/screens/lead_details_screen.dart';
import '../../features/revenue/presentation/screens/revenue_details_screen.dart';
import '../../features/sold_apartments/presentation/screens/sold_apartments_screen.dart';

final router = GoRouter(
  initialLocation: '/loading',
  routes: [
    GoRoute(
      name: 'loading',
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      name: 'onboarding',
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      name: 'login_page',
      path: '/login_page',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: 'otp_page',
      path: '/otp_page',
      builder: (context, state) {
        String phone = '+998 90 123 45 67';
        String name = '';
        OtpFlow flow = OtpFlow.forgotPassword;
        final extra = state.extra;
        if (extra is String) {
          phone = extra;
        } else if (extra is Map<String, dynamic>) {
          final extraPhone = extra['phone'];
          final extraName = extra['name'];
          final extraFlow = extra['flow'];
          if (extraPhone is String && extraPhone.isNotEmpty) {
            phone = extraPhone;
          }
          if (extraName is String) {
            name = extraName;
          }
          if (extraFlow is OtpFlow) {
            flow = extraFlow;
          }
        }
        return OtpPage(
          phoneNumber: phone,
          name: name,
          flow: flow,
        );
      },
    ),
    GoRoute(
      name: 'setup_user_info',
      path: '/setup_user_info',
      builder: (context, state) {
        String phone = '';
        String name = '';
        final extra = state.extra;
        if (extra is Map<String, dynamic>) {
          final extraPhone = extra['phone'];
          final extraName = extra['name'];
          if (extraPhone is String && extraPhone.isNotEmpty) {
            phone = extraPhone;
          }
          if (extraName is String) {
            name = extraName;
          }
        }
        return SetUpUserInfoPage(
          phoneNumber: phone,
          name: name,
        );
      },
    ),
    GoRoute(
      name: 'forgot_password',
      path: '/forgot_password',
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      name: 'reset_password',
      path: '/reset_password',
      builder: (context, state) {
        String phone = '';
        String code = '';
        final extra = state.extra;
        if (extra is Map<String, dynamic>) {
          final extraPhone = extra['phone'];
          final extraCode = extra['code'];
          if (extraPhone is String) {
            phone = extraPhone;
          }
          if (extraCode is String) {
            code = extraCode;
          }
        }
        return ResetPassword(
          phone: phone,
          code: code,
        );
      },
    ),
    GoRoute(
      name: 'pin_code',
      path: '/pin_code',
      builder: (context, state) => const PinCodePage(),
    ),
    GoRoute(
      name: 'dashboard',
      path: '/dashboard',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MainShellScreen(
          child: DashboardScreen(),
        ),
      ),
    ),
    GoRoute(
      name: 'analytics',
      path: '/analytics',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MainShellScreen(
          child: AnalyticsScreen(),
        ),
      ),
    ),
    GoRoute(
      name: 'projects',
      path: '/projects',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MainShellScreen(
          child: ProjectsPage(),
        ),
      ),
    ),
    GoRoute(
      name: 'finance',
      path: '/finance',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MainShellScreen(
          child: FinanceScreen(),
        ),
      ),
    ),
    GoRoute(
      name: 'approvals',
      path: '/approvals',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MainShellScreen(
          child: ApprovalsScreen(),
        ),
      ),
    ),
    GoRoute(
      name: 'approval_detail',
      path: '/approvals/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ApprovalDetailScreen(approvalId: id);
      },
    ),
    GoRoute(
      name: 'project_details_premium',
      path: '/project/details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProjectDetailsScreen(projectId: id);
      },
    ),
    GoRoute(
      name: 'project_detail',
      path: '/project/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProjectDetailScreenNew(projectId: id);
      },
    ),
    GoRoute(
      name: 'apartment_detail',
      path: '/apartment/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ApartmentDetailScreen(apartmentId: id);
      },
    ),
    GoRoute(
      name: 'notifications',
      path: '/notifications',
      builder: (context, state) => BlocProvider(
        create: (context) => GetIt.I<NotificationsCubit>(),
        child: const NotificationsScreen(),
      ),
    ),
    GoRoute(
      name: 'revenue_details',
      path: '/revenue-details',
      builder: (context, state) => const RevenueDetailsScreen(),
    ),
    GoRoute(
      name: 'sold_apartments',
      path: '/sold-apartments',
      builder: (context, state) => const SoldApartmentsScreen(),
    ),
    GoRoute(
      name: 'sales_dynamics',
      path: '/sales-dynamics',
      builder: (context, state) => const SalesDynamicsPage(),
    ),
    GoRoute(
      name: 'funnel_analysis',
      path: '/funnel-analysis',
      builder: (context, state) => const FunnelAnalysisPage(),
    ),
    GoRoute(
      name: 'all_payments',
      path: '/all-payments',
      builder: (context, state) => const AllPaymentsScreen(),
    ),
    GoRoute(
      name: 'settings',
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      name: 'leads',
      path: '/leads',
      builder: (context, state) => const LeadsScreen(),
    ),
    GoRoute(
      name: 'lead_details',
      path: '/leads/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return LeadDetailsScreen(leadId: id);
      },
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      name: 'profile_details',
      path: '/profile/details',
      builder: (context, state) => const ProfileDetailsScreen(),
    ),
    GoRoute(
      name: 'profile_edit',
      path: '/profile/edit',
      builder: (context, state) => BlocProvider(
        create: (context) => GetIt.I<ProfileCubit>()..loadProfile(),
        child: const EditProfileScreen(),
      ),
    ),
    GoRoute(
      name: 'profile_company',
      path: '/profile/company',
      builder: (context, state) => const CompanyInfoScreen(),
    ),
    GoRoute(
      name: 'profile_pin_change',
      path: '/profile/pin-change',
      builder: (context, state) => BlocProvider.value(
        value: GetIt.I<AppLockBloc>(),
        child: const PinCodePage(popOnComplete: true),
      ),
    ),
    GoRoute(
      name: 'profile_devices',
      path: '/profile/devices',
      builder: (context, state) => const DevicesScreen(),
    ),
    GoRoute(
      name: 'profile_session_timeout',
      path: '/profile/session-timeout',
      builder: (context, state) => const SessionTimeoutScreen(),
    ),
    GoRoute(
      name: 'profile_language',
      path: '/profile/language',
      builder: (context, state) {
        // Check if showContinueButton is passed via extra
        final extra = state.extra;
        bool showContinueButton = false;
        if (extra is Map<String, dynamic>) {
          showContinueButton = extra['showContinueButton'] == true;
        } else if (extra is bool) {
          showContinueButton = extra;
        }
        return LanguageScreen(showContinueButton: showContinueButton);
      },
    ),
    GoRoute(
      name: 'profile_about',
      path: '/profile/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      name: 'profile_support',
      path: '/profile/support',
      builder: (context, state) => const SupportScreen(),
    ),
  ],
);
