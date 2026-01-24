import 'package:dartz/dartz.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../repositories/app_lock_repository.dart';

class ClearAppLockData extends UseCase<Unit, NoParams> {
  final AppLockRepository repository;

  ClearAppLockData(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.clearAppLockData();
  }
}
