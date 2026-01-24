import 'package:dartz/dartz.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../repositories/app_lock_repository.dart';

class AuthenticateBiometric extends UseCase<bool, NoParams> {
  final AppLockRepository repository;

  AuthenticateBiometric(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.authenticateWithBiometric();
  }
}
