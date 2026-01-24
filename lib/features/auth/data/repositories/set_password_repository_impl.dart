import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../../domain/entities/set_password_response.dart';
import '../../domain/repositories/set_password_repository.dart';
import '../datasources/remote/set_password_remote_datasource.dart';

class SetPasswordRepositoryImpl implements SetPasswordRepository {
  final SetPasswordRemoteDataSource remoteDataSource;

  SetPasswordRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, SetPasswordResponseEntity>> setPassword({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.setPassword(
        phone: phone,
        password: password,
      );
      return Right(response.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerExceptions catch (e) {
      if (e.statusCode == 400 || e.statusCode == 422) {
        return Left(ValidationFailure(e.message));
      }
      return Left(ServerFailure(_withStatusCode(e.message, e.statusCode)));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error occurred.'));
    }
  }

  String _withStatusCode(String message, int? statusCode) {
    if (statusCode == null) return message;
    return '($statusCode) $message';
  }
}
