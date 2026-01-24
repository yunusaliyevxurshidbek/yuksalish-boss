import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_repository.dart';

/// Use case for logging out from all devices.
///
/// If [keepCurrent] is true, the current device session is preserved,
/// effectively logging out only from other devices.
class LogoutAllDevices extends UseCase<void, LogoutAllDevicesParams> {
  final DeviceRepository repository;

  LogoutAllDevices(this.repository);

  @override
  Future<Either<Failure, void>> call(LogoutAllDevicesParams params) {
    return repository.logoutAllDevices(
      currentDeviceId: params.currentDeviceId,
      keepCurrent: params.keepCurrent,
    );
  }
}

class LogoutAllDevicesParams extends Equatable {
  /// The current device's UUID for the X-Device-ID header.
  final String currentDeviceId;

  /// Whether to preserve the current device session.
  final bool keepCurrent;

  const LogoutAllDevicesParams({
    required this.currentDeviceId,
    required this.keepCurrent,
  });

  @override
  List<Object?> get props => [currentDeviceId, keepCurrent];
}
