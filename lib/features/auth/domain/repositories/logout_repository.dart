import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../entities/logout_response.dart';

abstract class LogoutRepository {
  Future<Either<Failure, LogoutResponseEntity>> logout({
    required String refreshToken,
  });
}
