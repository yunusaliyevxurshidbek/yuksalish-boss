import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_repository.dart';

/// Use case for terminating a specific device session.
///
/// Used to remotely log out another device.
class TerminateSession extends UseCase<void, TerminateSessionParams> {
  final DeviceRepository repository;

  TerminateSession(this.repository);

  @override
  Future<Either<Failure, void>> call(TerminateSessionParams params) {
    return repository.terminateSession(params.deviceId);
  }
}

class TerminateSessionParams extends Equatable {
  /// The database ID of the device to terminate (not the hardware UUID).
  final int deviceId;

  const TerminateSessionParams({required this.deviceId});

  @override
  List<Object?> get props => [deviceId];
}
