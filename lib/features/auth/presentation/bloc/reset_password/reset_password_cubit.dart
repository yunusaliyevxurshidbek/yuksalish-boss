import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/reset_password.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordCubit(this._resetPasswordUseCase)
      : super(const ResetPasswordInitial());

  Future<void> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    emit(const ResetPasswordLoading());

    final result = await _resetPasswordUseCase(
      phone: phone,
      code: code,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(ResetPasswordError(failure.message)),
      (response) => emit(ResetPasswordSuccess(response)),
    );
  }

  void reset() {
    emit(const ResetPasswordInitial());
  }
}
