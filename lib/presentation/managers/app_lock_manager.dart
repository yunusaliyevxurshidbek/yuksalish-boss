import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_lock_constants.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_bloc.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_event.dart';
import 'package:yuksalish_mobile/features/app_lock/presentation/bloc/app_lock/app_lock_state.dart';

class AppLockManager extends StatefulWidget {
  final Widget child;
  final GoRouter router;

  const AppLockManager({
    super.key,
    required this.child,
    required this.router,
  });

  @override
  State<AppLockManager> createState() => _AppLockManagerState();
}

class _AppLockManagerState extends State<AppLockManager>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;
  bool _biometricPromptPending = false;
  StreamSubscription<AppLockState>? _stateSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialLockStatus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stateSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _onAppBackgrounded();
        break;
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _checkInitialLockStatus() {
    final bloc = context.read<AppLockBloc>();
    bloc.add(const AppLockInitialize());

    _stateSubscription = bloc.stream.listen((state) {
      if (state.isPinConfigured && state.mode == AppLockMode.verify) {
        _redirectToLockScreen();

        if (state.isBiometricEnabled &&
            !_biometricPromptPending &&
            !state.isLockedOut) {
          _biometricPromptPending = true;
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              bloc.add(const AppLockBiometricRequested());
            }
          });
        }
      } else if (state.mode == AppLockMode.unlocked) {
        _biometricPromptPending = false;
      }
    });
  }

  void _onAppBackgrounded() {
    _backgroundedAt = DateTime.now();

    final bloc = context.read<AppLockBloc>();
    bloc.add(const AppLockBackgrounded());
  }

  void _onAppResumed() {
    if (_backgroundedAt == null) return;

    final bloc = context.read<AppLockBloc>();
    final state = bloc.state;

    if (!state.isPinConfigured || state.mode == AppLockMode.setup) {
      _backgroundedAt = null;
      return;
    }

    final backgroundDuration = DateTime.now().difference(_backgroundedAt!);

    if (backgroundDuration.inSeconds >=
        AppLockConstants.backgroundTimeoutSeconds) {
      bloc.add(const AppLockLock());
      _redirectToLockScreen();

      if (state.isBiometricEnabled &&
          !state.isLockedOut &&
          !_biometricPromptPending) {
        _biometricPromptPending = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            bloc.add(const AppLockBiometricRequested());
          }
        });
      }
    }

    _backgroundedAt = null;
  }

  void _redirectToLockScreen() {
    final currentLocation =
        widget.router.routerDelegate.currentConfiguration.uri.toString();

    if (currentLocation.contains('pin_code') ||
        currentLocation.contains('splash') ||
        currentLocation.contains('loading')) {
      return;
    }

    widget.router.go('/pin_code');
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

extension AppLockManagerExtension on BuildContext {
  bool get isAppLocked {
    try {
      final state = read<AppLockBloc>().state;
      return state.isPinConfigured && state.mode == AppLockMode.verify;
    } catch (_) {
      return false;
    }
  }
}
