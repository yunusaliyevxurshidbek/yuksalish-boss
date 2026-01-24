import 'package:dartz/dartz.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/remote/login_remote_datasource.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, LoginResponseEntity>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
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
