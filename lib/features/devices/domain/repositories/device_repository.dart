import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/device_info.dart';
import '../entities/user_device.dart';

/// Abstract repository contract for device management operations.
abstract class DeviceRepository {
  /// Registers or updates the current device with the backend.
  ///
  /// Called on app launch or after successful login.
  /// Returns the registered [UserDevice] on success.
  Future<Either<Failure, UserDevice>> registerDevice(DeviceInfo deviceInfo);

  /// Retrieves the list of all devices registered for the current user.
  ///
  /// The current device is identified by [currentDeviceId] and marked
  /// with `is_current: true` in the response.
  Future<Either<Failure, List<UserDevice>>> getUserDevices(
    String currentDeviceId,
  );

  /// Terminates a specific device session by its database ID.
  ///
  /// Used to remotely log out another device.
  Future<Either<Failure, void>> terminateSession(int deviceId);

  /// Logs out from all devices.
  ///
  /// If [keepCurrent] is true, the current device session is preserved.
  Future<Either<Failure, void>> logoutAllDevices({
    required String currentDeviceId,
    required bool keepCurrent,
  });
}
