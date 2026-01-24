import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yuksalish_mobile/core/constants/app_lock_constants.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../../../domain/entities/lock_status.dart';
import '../../../domain/usecases/authenticate_biometric.dart';
import '../../../domain/usecases/check_biometrics_available.dart';
import '../../../domain/usecases/clear_app_lock_data.dart';
import '../../../domain/usecases/get_lock_status.dart';
import '../../../domain/usecases/record_failed_attempt.dart';
import '../../../domain/usecases/setup_pin.dart';
import '../../../domain/usecases/toggle_biometric.dart';
import '../../../domain/usecases/verify_pin.dart';
import 'app_lock_event.dart';
import 'app_lock_state.dart';

class AppLockBloc extends Bloc<AppLockEvent, AppLockState> {
  final SetupPin _setupPin;
  final VerifyPin _verifyPin;
  final ToggleBiometric _toggleBiometric;
  final AuthenticateBiometric _authenticateBiometric;
  final CheckBiometricsAvailable _checkBiometricsAvailable;
  final GetLockStatus _getLockStatus;
  final RecordFailedAttempt _recordFailedAttempt;
  final ClearAppLockData _clearAppLockData;

  Timer? _lockoutTimer;

  AppLockBloc({
    required SetupPin setupPin,
    required VerifyPin verifyPin,
    required ToggleBiometric toggleBiometric,
    required AuthenticateBiometric authenticateBiometric,
    required CheckBiometricsAvailable checkBiometricsAvailable,
    required GetLockStatus getLockStatus,
    required RecordFailedAttempt recordFailedAttempt,
    required ClearAppLockData clearAppLockData,
  })  : _setupPin = setupPin,
        _verifyPin = verifyPin,
        _toggleBiometric = toggleBiometric,
        _authenticateBiometric = authenticateBiometric,
        _checkBiometricsAvailable = checkBiometricsAvailable,
        _getLockStatus = getLockStatus,
        _recordFailedAttempt = recordFailedAttempt,
        _clearAppLockData = clearAppLockData,
        super(AppLockState.initial()) {
    on<AppLockInitialize>(_onInitialize);
    on<AppLockPinDigitEntered>(_onPinDigitEntered);
    on<AppLockPinDigitDeleted>(_onPinDigitDeleted);
    on<AppLockPinCleared>(_onPinCleared);
    on<AppLockStartSetup>(_onStartSetup);
    on<AppLockStartChange>(_onStartChange);
    on<AppLockPinEntered>(_onPinEntered);
    on<AppLockConfirmPin>(_onConfirmPin);
    on<AppLockVerifyPin>(_onVerifyPin);
    on<AppLockToggleBiometric>(_onToggleBiometric);
    on<AppLockBiometricRequested>(_onBiometricRequested);
    on<AppLockBackgrounded>(_onBackgrounded);
    on<AppLockResumed>(_onResumed);
    on<AppLockUnlock>(_onUnlock);
    on<AppLockLock>(_onLock);
    on<AppLockReset>(_onReset);
    on<AppLockLockoutTick>(_onLockoutTick);
  }

  @override
  Future<void> close() {
    _lockoutTimer?.cancel();
    return super.close();
  }

  Future<void> _onInitialize(
    AppLockInitialize event,
    Emitter<AppLockState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // Check lock status
    final lockStatusResult = await _getLockStatus(const NoParams());
    final biometricResult = await _checkBiometricsAvailable(const NoParams());

    await lockStatusResult.fold(
      (failure) async {
        emit(state.copyWith(
          mode: AppLockMode.setup,
          isPinConfigured: false,
          isLoading: false,
          isInitialized: true,
        ));
      },
      (lockStatus) async {
        final biometricAvailable = biometricResult.fold((_) => false, (v) => v);

        if (lockStatus.state == LockState.unconfigured) {
          emit(state.copyWith(
            mode: AppLockMode.setup,
            isPinConfigured: false,
            isBiometricAvailable: biometricAvailable,
            isLoading: false,
            isInitialized: true,
          ));
        } else if (lockStatus.state == LockState.lockedOut) {
          _startLockoutTimer(lockStatus.lockoutRemaining!);
          emit(state.copyWith(
            mode: AppLockMode.verify,
            isPinConfigured: true,
            isBiometricAvailable: biometricAvailable,
            isBiometricEnabled: lockStatus.canUseBiometrics,
            isLockedOut: true,
            lockoutRemaining: lockStatus.lockoutRemaining,
            isLoading: false,
            isInitialized: true,
          ));
        } else {
          emit(state.copyWith(
            mode: AppLockMode.verify,
            isPinConfigured: true,
            isBiometricAvailable: biometricAvailable,
            isBiometricEnabled: lockStatus.canUseBiometrics,
            failedAttempts: lockStatus.failedAttempts,
            maxAttempts: lockStatus.maxAttempts,
            isLoading: false,
            isInitialized: true,
          ));
        }
      },
    );
  }

  void _onPinDigitEntered(
    AppLockPinDigitEntered event,
    Emitter<AppLockState> emit,
  ) {
    if (!state.canEnterDigit) return;

    final newPin = state.currentPin + event.digit;
    emit(state.copyWith(currentPin: newPin, clearError: true));

    // Auto-submit when PIN is complete
    if (newPin.length == AppLockConstants.pinLength) {
      switch (state.mode) {
        case AppLockMode.setup:
          add(AppLockPinEntered(newPin));
          break;
        case AppLockMode.confirm:
          add(AppLockConfirmPin(newPin));
          break;
        case AppLockMode.verify:
          add(AppLockVerifyPin(newPin));
          break;
        case AppLockMode.unlocked:
          break;
        case AppLockMode.changeVerify:
          add(AppLockVerifyPin(newPin));
          break;
        case AppLockMode.changeSetup:
          add(AppLockPinEntered(newPin));
          break;
        case AppLockMode.changeConfirm:
          add(AppLockConfirmPin(newPin));
          break;
      }
    }
  }

  void _onPinDigitDeleted(
    AppLockPinDigitDeleted event,
    Emitter<AppLockState> emit,
  ) {
    if (!state.canDeleteDigit) return;
    emit(state.copyWith(
      currentPin: state.currentPin.substring(0, state.currentPin.length - 1),
    ));
  }

  void _onPinCleared(
    AppLockPinCleared event,
    Emitter<AppLockState> emit,
  ) {
    emit(state.copyWith(currentPin: '', clearError: true));
  }

  void _onStartSetup(
    AppLockStartSetup event,
    Emitter<AppLockState> emit,
  ) {
    emit(state.copyWith(
      mode: AppLockMode.setup,
      currentPin: '',
      clearFirstPin: true,
      clearError: true,
    ));
  }

  void _onStartChange(
    AppLockStartChange event,
    Emitter<AppLockState> emit,
  ) {
    emit(state.copyWith(
      mode: AppLockMode.changeVerify,
      currentPin: '',
      clearFirstPin: true,
      clearError: true,
      failedAttempts: 0,
    ));
  }

  Future<void> _onPinEntered(
    AppLockPinEntered event,
    Emitter<AppLockState> emit,
  ) async {
    // Store first PIN and move to confirmation
    final nextMode = state.mode == AppLockMode.changeSetup
        ? AppLockMode.changeConfirm
        : AppLockMode.confirm;
    emit(state.copyWith(
      mode: nextMode,
      firstPin: event.pin,
      currentPin: '',
    ));
  }

  Future<void> _onConfirmPin(
    AppLockConfirmPin event,
    Emitter<AppLockState> emit,
  ) async {
    final isChangeFlow = state.mode == AppLockMode.changeConfirm;
    final setupMode = isChangeFlow ? AppLockMode.changeSetup : AppLockMode.setup;

    if (state.firstPin == null) {
      emit(state.copyWith(
        mode: setupMode,
        currentPin: '',
        error: isChangeFlow ? 'Qaytadan boshlang' : 'Please start over',
      ));
      return;
    }

    // Check if PINs match
    if (event.pin != state.firstPin) {
      emit(state.copyWith(
        mode: setupMode,
        currentPin: '',
        clearFirstPin: true,
        error: isChangeFlow
            ? 'PIN kodlar mos kelmadi. Qaytadan urinib ko\'ring.'
            : 'PINs do not match. Please try again.',
      ));
      return;
    }

    // PINs match - save the PIN
    emit(state.copyWith(isLoading: true));

    final result = await _setupPin(SetupPinParams(pin: event.pin));

    result.fold(
      (failure) {
        emit(state.copyWith(
          mode: setupMode,
          currentPin: '',
          clearFirstPin: true,
          isLoading: false,
          error: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(
          mode: AppLockMode.unlocked,
          isPinConfigured: true,
          currentPin: '',
          clearFirstPin: true,
          isLoading: false,
        ));
      },
    );
  }

  Future<void> _onVerifyPin(
    AppLockVerifyPin event,
    Emitter<AppLockState> emit,
  ) async {
    if (state.isLockedOut) return;

    emit(state.copyWith(isLoading: true));

    final result = await _verifyPin(VerifyPinParams(pin: event.pin));

    await result.fold(
      (failure) async {
        emit(state.copyWith(
          currentPin: '',
          isLoading: false,
          error: failure.message,
        ));
      },
      (isValid) async {
        if (isValid) {
          // Check if we're in PIN change flow
          if (state.mode == AppLockMode.changeVerify) {
            emit(state.copyWith(
              mode: AppLockMode.changeSetup,
              currentPin: '',
              isLoading: false,
              failedAttempts: 0,
              clearError: true,
            ));
          } else {
            emit(state.copyWith(
              mode: AppLockMode.unlocked,
              currentPin: '',
              isLoading: false,
              failedAttempts: 0,
              clearError: true,
            ));
          }
        } else {
          // Record failed attempt
          final attemptResult = await _recordFailedAttempt(const NoParams());

          attemptResult.fold(
            (failure) {
              emit(state.copyWith(
                currentPin: '',
                isLoading: false,
                error: 'Incorrect PIN',
              ));
            },
            (lockStatus) {
              if (lockStatus.isLockedOut) {
                _startLockoutTimer(lockStatus.lockoutRemaining!);
                emit(state.copyWith(
                  currentPin: '',
                  isLoading: false,
                  isLockedOut: true,
                  lockoutRemaining: lockStatus.lockoutRemaining,
                  failedAttempts: 0,
                  clearError: true,
                ));
              } else {
                emit(state.copyWith(
                  currentPin: '',
                  isLoading: false,
                  failedAttempts: lockStatus.failedAttempts,
                  error: 'Incorrect PIN',
                ));
              }
            },
          );
        }
      },
    );
  }

  Future<void> _onToggleBiometric(
    AppLockToggleBiometric event,
    Emitter<AppLockState> emit,
  ) async {
    // Check if biometrics are available
    if (event.enabled && !state.isBiometricAvailable) {
      emit(state.copyWith(error: 'Biometrik bu qurilmada mavjud emas'));
      return;
    }

    // If enabling, require biometric authentication first
    if (event.enabled) {
      emit(state.copyWith(biometricPromptShowing: true));

      final authResult = await _authenticateBiometric(const NoParams());

      final authenticated = authResult.fold((_) => false, (v) => v);

      if (!authenticated) {
        emit(state.copyWith(
          biometricPromptShowing: false,
          error: 'Biometrikni yoqish uchun autentifikatsiya talab qilinadi',
        ));
        return;
      }
    }

    final result =
        await _toggleBiometric(ToggleBiometricParams(enabled: event.enabled));

    result.fold(
      (failure) {
        emit(state.copyWith(
          biometricPromptShowing: false,
          error: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(
          isBiometricEnabled: event.enabled,
          biometricPromptShowing: false,
          clearError: true,
        ));
      },
    );
  }

  Future<void> _onBiometricRequested(
    AppLockBiometricRequested event,
    Emitter<AppLockState> emit,
  ) async {
    if (!state.isBiometricEnabled ||
        state.isLockedOut ||
        state.biometricPromptShowing) {
      return;
    }

    emit(state.copyWith(biometricPromptShowing: true));

    final result = await _authenticateBiometric(const NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(
          biometricPromptShowing: false,
          // Don't show error for user cancellation
        ));
      },
      (authenticated) {
        if (authenticated) {
          emit(state.copyWith(
            mode: AppLockMode.unlocked,
            currentPin: '',
            biometricPromptShowing: false,
            failedAttempts: 0,
          ));
        } else {
          emit(state.copyWith(biometricPromptShowing: false));
        }
      },
    );
  }

  void _onBackgrounded(
    AppLockBackgrounded event,
    Emitter<AppLockState> emit,
  ) {
    // This is handled by AppLockManager
  }

  void _onResumed(
    AppLockResumed event,
    Emitter<AppLockState> emit,
  ) {
    // This is handled by AppLockManager
  }

  void _onUnlock(
    AppLockUnlock event,
    Emitter<AppLockState> emit,
  ) {
    emit(state.copyWith(
      mode: AppLockMode.unlocked,
      currentPin: '',
      failedAttempts: 0,
      clearError: true,
    ));
  }

  void _onLock(
    AppLockLock event,
    Emitter<AppLockState> emit,
  ) {
    if (state.isPinConfigured) {
      emit(state.copyWith(
        mode: AppLockMode.verify,
        currentPin: '',
        clearError: true,
      ));
    }
  }

  Future<void> _onReset(
    AppLockReset event,
    Emitter<AppLockState> emit,
  ) async {
    // Clear stored PIN and biometric data from secure storage
    await _clearAppLockData(const NoParams());

    emit(state.copyWith(
      mode: AppLockMode.setup,
      currentPin: '',
      clearFirstPin: true,
      isPinConfigured: false,
      isBiometricEnabled: false,
      failedAttempts: 0,
      clearError: true,
      clearLockout: true,
      isLockedOut: false,
    ));
  }

  void _onLockoutTick(
    AppLockLockoutTick event,
    Emitter<AppLockState> emit,
  ) {
    if (event.remaining.inSeconds <= 0) {
      _lockoutTimer?.cancel();
      emit(state.copyWith(
        isLockedOut: false,
        clearLockout: true,
      ));
    } else {
      emit(state.copyWith(lockoutRemaining: event.remaining));
    }
  }

  void _startLockoutTimer(Duration duration) {
    _lockoutTimer?.cancel();
    var remaining = duration;

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining = remaining - const Duration(seconds: 1);
      add(AppLockLockoutTick(remaining));

      if (remaining.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }
}
