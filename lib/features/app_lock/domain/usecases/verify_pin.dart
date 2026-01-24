import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../repositories/app_lock_repository.dart';

class VerifyPin extends UseCase<bool, VerifyPinParams> {
  final AppLockRepository repository;

  VerifyPin(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyPinParams params) {
    return repository.verifyPin(params.pin);
  }
}

class VerifyPinParams extends Equatable {
  final String pin;

  const VerifyPinParams({required this.pin});

  @override
  List<Object?> get props => [pin];
}
