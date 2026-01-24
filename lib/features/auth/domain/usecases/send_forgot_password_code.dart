import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yuksalish_mobile/core/error/failures.dart';
import 'package:yuksalish_mobile/core/usecases/usecase.dart';
import '../entities/forgot_password_response.dart';
import '../repositories/forgot_password_repository.dart';

class SendForgotPasswordCode
    extends UseCase<ForgotPasswordResponseEntity, SendForgotPasswordCodeParams> {
  final ForgotPasswordRepository repository;

  SendForgotPasswordCode(this.repository);

  @override
  Future<Either<Failure, ForgotPasswordResponseEntity>> call(
    SendForgotPasswordCodeParams params,
  ) {
    return repository.sendForgotPasswordCode(
      phone: params.phone,
      source: params.source,
    );
  }
}

class SendForgotPasswordCodeParams extends Equatable {
  final String phone;
  final String source;

  const SendForgotPasswordCodeParams({
    required this.phone,
    this.source = 'website',
  });

  @override
  List<Object?> get props => [phone, source];
}
