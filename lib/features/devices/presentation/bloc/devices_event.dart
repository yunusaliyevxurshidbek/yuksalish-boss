part of 'devices_bloc.dart';

/// Base class for all device management events.
abstract class DevicesEvent extends Equatable {
  const DevicesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all user devices.
class LoadDevices extends DevicesEvent {
  const LoadDevices();
}

/// Event to refresh the device list.
class RefreshDevices extends DevicesEvent {
  const RefreshDevices();
}

/// Event to terminate a specific device session.
class TerminateDeviceSession extends DevicesEvent {
  /// The database ID of the device to terminate.
  final int deviceId;

  const TerminateDeviceSession({required this.deviceId});

  @override
  List<Object?> get props => [deviceId];
}

/// Event to logout from all devices.
class LogoutFromAllDevices extends DevicesEvent {
  /// Whether to keep the current device session.
  final bool keepCurrent;

  const LogoutFromAllDevices({required this.keepCurrent});

  @override
  List<Object?> get props => [keepCurrent];
}

/// Event to register the current device (background operation).
class RegisterCurrentDevice extends DevicesEvent {
  const RegisterCurrentDevice();
}
