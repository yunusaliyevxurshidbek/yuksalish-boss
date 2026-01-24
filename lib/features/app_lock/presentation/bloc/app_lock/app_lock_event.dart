import 'package:equatable/equatable.dart';

abstract class AppLockEvent extends Equatable {
  const AppLockEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize app lock state on app start
class AppLockInitialize extends AppLockEvent {
  const AppLockInitialize();
}

/// User enters a digit during PIN input
class AppLockPinDigitEntered extends AppLockEvent {
  final String digit;
  const AppLockPinDigitEntered(this.digit);

  @override
  List<Object?> get props => [digit];
}

/// User deletes a digit
class AppLockPinDigitDeleted extends AppLockEvent {
  const AppLockPinDigitDeleted();
}

/// User clears the PIN input
class AppLockPinCleared extends AppLockEvent {
  const AppLockPinCleared();
}

/// Start PIN setup flow
class AppLockStartSetup extends AppLockEvent {
  const AppLockStartSetup();
}

/// Start PIN change flow (verify current PIN first)
class AppLockStartChange extends AppLockEvent {
  const AppLockStartChange();
}

/// First PIN entered, now confirm
class AppLockPinEntered extends AppLockEvent {
  final String pin;
  const AppLockPinEntered(this.pin);

  @override
  List<Object?> get props => [pin];
}

/// Confirm PIN (second entry during setup)
class AppLockConfirmPin extends AppLockEvent {
  final String pin;
  const AppLockConfirmPin(this.pin);

  @override
  List<Object?> get props => [pin];
}

/// Verify PIN during unlock
class AppLockVerifyPin extends AppLockEvent {
  final String pin;
  const AppLockVerifyPin(this.pin);

  @override
  List<Object?> get props => [pin];
}

/// Toggle biometric authentication
class AppLockToggleBiometric extends AppLockEvent {
  final bool enabled;
  const AppLockToggleBiometric(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

/// Attempt biometric authentication
class AppLockBiometricRequested extends AppLockEvent {
  const AppLockBiometricRequested();
}

/// App went to background
class AppLockBackgrounded extends AppLockEvent {
  const AppLockBackgrounded();
}

/// App came to foreground
class AppLockResumed extends AppLockEvent {
  const AppLockResumed();
}

/// Unlock the app (after successful auth)
class AppLockUnlock extends AppLockEvent {
  const AppLockUnlock();
}

/// Lock the app manually
class AppLockLock extends AppLockEvent {
  const AppLockLock();
}

/// Reset app lock (clear PIN)
class AppLockReset extends AppLockEvent {
  const AppLockReset();
}

/// Lockout timer tick
class AppLockLockoutTick extends AppLockEvent {
  final Duration remaining;
  const AppLockLockoutTick(this.remaining);

  @override
  List<Object?> get props => [remaining];
}
