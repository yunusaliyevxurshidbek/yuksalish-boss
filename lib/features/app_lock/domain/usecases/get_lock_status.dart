import 'package:dartz/dartz.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../entities/lock_status.dart';
import '../repositories/app_lock_repository.dart';

class GetLockStatus extends UseCase<LockStatus, NoParams> {
  final AppLockRepository repository;

  GetLockStatus(this.repository);

  @override
  Future<Either<Failure, LockStatus>> call(NoParams params) {
    return repository.getLockStatus();
  }
}
