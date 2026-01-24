import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/device_info_service.dart';
import '../../domain/entities/user_device.dart';
import '../../domain/usecases/get_user_devices.dart';
import '../../domain/usecases/logout_all_devices.dart';
import '../../domain/usecases/register_device.dart';
import '../../domain/usecases/terminate_session.dart';

part 'devices_event.dart';
part 'devices_state.dart';

/// BLoC for managing user device sessions.
class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  final GetUserDevices _getUserDevices;
  final TerminateSession _terminateSession;
  final LogoutAllDevices _logoutAllDevices;
  final RegisterDevice _registerDevice;
  final DeviceInfoService _deviceInfoService;

  DevicesBloc({
    required GetUserDevices getUserDevices,
    required TerminateSession terminateSession,
    required LogoutAllDevices logoutAllDevices,
    required RegisterDevice registerDevice,
    required DeviceInfoService deviceInfoService,
  })  : _getUserDevices = getUserDevices,
        _terminateSession = terminateSession,
        _logoutAllDevices = logoutAllDevices,
        _registerDevice = registerDevice,
        _deviceInfoService = deviceInfoService,
        super(DevicesState.initial()) {
    on<LoadDevices>(_onLoadDevices);
    on<RefreshDevices>(_onRefreshDevices);
    on<TerminateDeviceSession>(_onTerminateSession);
    on<LogoutFromAllDevices>(_onLogoutAllDevices);
    on<RegisterCurrentDevice>(_onRegisterCurrentDevice);
  }

  Future<void> _onLoadDevices(
    LoadDevices event,
    Emitter<DevicesState> emit,
  ) async {
    emit(state.copyWith(status: DevicesStatus.loading));

    final deviceId = await _deviceInfoService.getOrCreateDeviceId();

    final result = await _getUserDevices(
      GetUserDevicesParams(currentDeviceId: deviceId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: DevicesStatus.error,
        errorMessage: failure.message,
      )),
      (devices) {
        final currentDevice = devices.where((d) => d.isCurrent).firstOrNull;
        final otherDevices = devices.where((d) => !d.isCurrent).toList();

        emit(state.copyWith(
          status: DevicesStatus.loaded,
          currentDevice: currentDevice,
          otherDevices: otherDevices,
          clearErrorMessage: true,
        ));
      },
    );
  }

  Future<void> _onRefreshDevices(
    RefreshDevices event,
    Emitter<DevicesState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    final deviceId = await _deviceInfoService.getOrCreateDeviceId();

    final result = await _getUserDevices(
      GetUserDevicesParams(currentDeviceId: deviceId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isRefreshing: false,
        errorMessage: failure.message,
      )),
      (devices) {
        final currentDevice = devices.where((d) => d.isCurrent).firstOrNull;
        final otherDevices = devices.where((d) => !d.isCurrent).toList();

        emit(state.copyWith(
          status: DevicesStatus.loaded,
          currentDevice: currentDevice,
          otherDevices: otherDevices,
          isRefreshing: false,
          clearErrorMessage: true,
        ));
      },
    );
  }

  Future<void> _onTerminateSession(
    TerminateDeviceSession event,
    Emitter<DevicesState> emit,
  ) async {
    emit(state.copyWith(
      operationStatus: DeviceOperationStatus.terminating,
      operatingDeviceId: event.deviceId,
    ));

    final result = await _terminateSession(
      TerminateSessionParams(deviceId: event.deviceId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        operationStatus: DeviceOperationStatus.failed,
        errorMessage: failure.message,
      )),
      (_) {
        // Remove the terminated device from the list
        final updatedOtherDevices = state.otherDevices
            .where((d) => d.id != event.deviceId)
            .toList();

        emit(state.copyWith(
          otherDevices: updatedOtherDevices,
          operationStatus: DeviceOperationStatus.terminated,
          successMessage: 'Device session terminated successfully.',
          operatingDeviceId: null,
        ));
      },
    );
  }

  Future<void> _onLogoutAllDevices(
    LogoutFromAllDevices event,
    Emitter<DevicesState> emit,
  ) async {
    emit(state.copyWith(operationStatus: DeviceOperationStatus.loggingOutAll));

    final deviceId = await _deviceInfoService.getOrCreateDeviceId();

    final result = await _logoutAllDevices(
      LogoutAllDevicesParams(
        currentDeviceId: deviceId,
        keepCurrent: event.keepCurrent,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        operationStatus: DeviceOperationStatus.failed,
        errorMessage: failure.message,
      )),
      (_) {
        if (event.keepCurrent) {
          // Clear other devices list
          emit(state.copyWith(
            otherDevices: const [],
            operationStatus: DeviceOperationStatus.loggedOutAll,
            successMessage: 'Signed out of all other devices.',
          ));
        } else {
          // User will be logged out completely
          emit(state.copyWith(
            operationStatus: DeviceOperationStatus.loggedOutAll,
            successMessage: 'Signed out of all devices.',
          ));
        }
      },
    );
  }

  Future<void> _onRegisterCurrentDevice(
    RegisterCurrentDevice event,
    Emitter<DevicesState> emit,
  ) async {
    // This is a background operation, don't show loading state
    try {
      final deviceInfo = await _deviceInfoService.getDeviceInfo();
      final result = await _registerDevice(
        RegisterDeviceParams(deviceInfo: deviceInfo),
      );

      result.fold(
        (failure) {
          // Log error but don't block UI
          log('[DevicesBloc] Device registration failed: ${failure.message}');
        },
        (device) {
          log('[DevicesBloc] Device registered successfully: ${device.id}');
        },
      );
    } catch (e) {
      log('[DevicesBloc] Device registration error: $e');
    }
  }

  /// Clears operation status for resetting UI state.
  void clearOperationStatus() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(
      operationStatus: DeviceOperationStatus.idle,
      clearErrorMessage: true,
      clearSuccessMessage: true,
    ));
  }
}
