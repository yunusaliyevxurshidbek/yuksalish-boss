import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/services/my_shared_preferences.dart';
import '../../../../core/services/version_check_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/force_update_dialog.dart';
import '../../../../injection_container.dart';
import '../../../app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import '../../../app_lock/presentation/bloc/app_lock/app_lock_state.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _minTimeElapsed = false;
  bool _hasNavigated = false;
  bool _updateRequired = false;

  @override
  void initState() {
    LogService.i(MySharedPreferences.getToken().toString());
    super.initState();
    _checkForUpdate();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _minTimeElapsed = true;
      _tryNavigate();
    });
  }

  Future<void> _checkForUpdate() async {
    final versionCheckService = getIt<VersionCheckService>();
    final config = await versionCheckService.checkForRequiredUpdate();
    if (!mounted) return;
    if (config != null) {
      _updateRequired = true;
      ForceUpdateDialog.show(
        context,
        config: config,
        versionCheckService: versionCheckService,
      );
    }
  }

  void _tryNavigate() {
    if (_hasNavigated || _updateRequired) return;

    final appLockBloc = context.read<AppLockBloc>();
    final state = appLockBloc.state;

    if (!_minTimeElapsed || !state.isInitialized) return;

    _hasNavigated = true;
    _navigateToNextPage(state);
  }

  void _navigateToNextPage(AppLockState appLockState) {
    final isFirstLaunchCompleted = MySharedPreferences.isFirstLaunchCompleted();

    if (!isFirstLaunchCompleted) {
      context.go('/onboarding');
      return;
    }

    final token = MySharedPreferences.getToken();
    if (token == null || token.isEmpty) {
      context.go('/login_page');
      return;
    }

    if (appLockState.isPinConfigured) {
      context.go('/dashboard');
    } else {
      context.go('/pin_code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppLockBloc, AppLockState>(
      listenWhen: (previous, current) =>
          !previous.isInitialized && current.isInitialized,
      listener: (context, state) {
        _tryNavigate();
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryNavy,
        appBar: AppBar(
          backgroundColor: AppColors.primaryNavy,
          surfaceTintColor: AppColors.primaryNavy,
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo_for_dark.png',
              ),
              Lottie.asset(
                'assets/animations/splash_loading.json',
                height: 70,
                width: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
