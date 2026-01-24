import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../entities/verify_otp_response.dart';
import '../repositories/verify_otp_repository.dart';

class VerifyOtp extends UseCase<VerifyOtpResponseEntity, VerifyOtpParams> {
  final VerifyOtpRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, VerifyOtpResponseEntity>> call(
    VerifyOtpParams params,
  ) {
    return repository.verifyOtp(
      phone: params.phone,
      code: params.code,
      name: params.name,
    );
  }
}

class VerifyOtpParams extends Equatable {
  final String phone;
  final String code;
  final String name;

  const VerifyOtpParams({
    required this.phone,
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [phone, code, name];
}
