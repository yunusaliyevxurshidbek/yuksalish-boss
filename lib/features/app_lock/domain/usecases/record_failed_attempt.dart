import 'package:dartz/dartz.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../entities/lock_status.dart';
import '../repositories/app_lock_repository.dart';

class RecordFailedAttempt extends UseCase<LockStatus, NoParams> {
  final AppLockRepository repository;

  RecordFailedAttempt(this.repository);

  @override
  Future<Either<Failure, LockStatus>> call(NoParams params) {
    return repository.recordFailedAttempt();
  }
}
