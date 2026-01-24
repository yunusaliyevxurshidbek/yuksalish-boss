import 'package:dartz/dartz.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../repositories/app_lock_repository.dart';

class CheckBiometricsAvailable extends UseCase<bool, NoParams> {
  final AppLockRepository repository;

  CheckBiometricsAvailable(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final availableResult = await repository.isBiometricAvailable();
    return availableResult.fold(
      (failure) => Left(failure),
      (available) async {
        if (!available) return const Right(false);
        final enrolledResult = await repository.isBiometricEnrolled();
        return enrolledResult.fold(
          (failure) => Left(failure),
          (enrolled) => Right(enrolled),
        );
      },
    );
  }
}
