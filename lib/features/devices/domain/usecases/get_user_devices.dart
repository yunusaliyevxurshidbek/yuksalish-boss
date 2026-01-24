import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_device.dart';
import '../repositories/device_repository.dart';

/// Use case for retrieving all devices registered for the current user.
class GetUserDevices extends UseCase<List<UserDevice>, GetUserDevicesParams> {
  final DeviceRepository repository;

  GetUserDevices(this.repository);

  @override
  Future<Either<Failure, List<UserDevice>>> call(GetUserDevicesParams params) {
    return repository.getUserDevices(params.currentDeviceId);
  }
}

class GetUserDevicesParams extends Equatable {
  final String currentDeviceId;

  const GetUserDevicesParams({required this.currentDeviceId});

  @override
  List<Object?> get props => [currentDeviceId];
}
