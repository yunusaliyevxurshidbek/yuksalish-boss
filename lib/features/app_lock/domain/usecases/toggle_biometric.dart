import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../repositories/app_lock_repository.dart';

class ToggleBiometric extends UseCase<Unit, ToggleBiometricParams> {
  final AppLockRepository repository;

  ToggleBiometric(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ToggleBiometricParams params) async {
    final configResult = await repository.getConfig();
    return configResult.fold(
      (failure) => Left(failure),
      (config) => repository.updateConfig(
        config.copyWith(isBiometricEnabled: params.enabled),
      ),
    );
  }
}

class ToggleBiometricParams extends Equatable {
  final bool enabled;

  const ToggleBiometricParams({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}
