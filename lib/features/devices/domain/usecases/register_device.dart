import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/device_info.dart';
import '../entities/user_device.dart';
import '../repositories/device_repository.dart';

/// Use case for registering or updating the current device.
///
/// This should be called:
/// - On app launch (if user is already logged in)
/// - After successful login
///
/// The call runs in the background and should not block the UI.
class RegisterDevice extends UseCase<UserDevice, RegisterDeviceParams> {
  final DeviceRepository repository;

  RegisterDevice(this.repository);

  @override
  Future<Either<Failure, UserDevice>> call(RegisterDeviceParams params) {
    return repository.registerDevice(params.deviceInfo);
  }
}

class RegisterDeviceParams extends Equatable {
  final DeviceInfo deviceInfo;

  const RegisterDeviceParams({required this.deviceInfo});

  @override
  List<Object?> get props => [deviceInfo];
}
