import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import '../../../domain/usecases/send_forgot_password_code.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendForgotPasswordCode _sendForgotPasswordCode;

  ForgotPasswordCubit(this._sendForgotPasswordCode)
      : super(const ForgotPasswordInitial());

  Future<void> sendCode({
    required String phone,
    String source = 'website',
  }) async {
    emit(const ForgotPasswordLoading());
    try {
      final result = await _sendForgotPasswordCode(
        SendForgotPasswordCodeParams(
          phone: phone,
          source: source,
        ),
      );
      result.fold(
        (failure) => emit(ForgotPasswordError(failure.message)),
        (response) => emit(
          ForgotPasswordSuccess(
            message: response.message,
            phone: phone,
            expiresIn: response.expiresIn,
          ),
        ),
      );
    } on NetworkException catch (e) {
      emit(ForgotPasswordError(e.message));
    } on ServerExceptions catch (e) {
      emit(ForgotPasswordError(e.message));
    } catch (_) {
      emit(const ForgotPasswordError('Unexpected error occurred.'));
    }
  }
}
