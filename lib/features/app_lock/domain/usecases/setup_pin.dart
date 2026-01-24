import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../repositories/app_lock_repository.dart';

class SetupPin extends UseCase<Unit, SetupPinParams> {
  final AppLockRepository repository;

  SetupPin(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SetupPinParams params) {
    return repository.setupPin(params.pin);
  }
}

class SetupPinParams extends Equatable {
  final String pin;

  const SetupPinParams({required this.pin});

  @override
  List<Object?> get props => [pin];
}
