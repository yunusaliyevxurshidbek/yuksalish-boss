import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../entities/logout_response.dart';
import '../repositories/logout_repository.dart';

class LogoutUser extends UseCase<LogoutResponseEntity, LogoutUserParams> {
  final LogoutRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, LogoutResponseEntity>> call(LogoutUserParams params) {
    return repository.logout(refreshToken: params.refreshToken);
  }
}

class LogoutUserParams extends Equatable {
  final String refreshToken;

  const LogoutUserParams({
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [refreshToken];
}
